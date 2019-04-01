
maindatadir = '/data/projects/ppi-effect-sizes';
basedir = pwd;

subs = load('Subject_Numbers.txt');
tasks = { 'SOCIAL', 'GAMBLING' };
run_names = {'LR', 'RL'};

% run-level metrics
fname = fullfile(basedir,'headmotion_run_LT.csv');
fid1 = fopen(fname,'w');
fprintf(fid1,'subj,task,run,abs_mean,rel_mean,pct_removed\n');

sub_data = zeros(length(subs),3,4);

for t = 1:length(tasks)
    task = tasks{t};
    
    % task-level metrics
    fname = fullfile(basedir,['headmotion_task-' task '_LT.csv']);
    fid2 = fopen(fname,'w');
    fprintf(fid2,'subj,abs_mean,rel_mean,pct_removed\n');
    %sub_mat =  zeros(4,3); % place to store the data
    for s = 1:length(subs)
        subnum = subs(s);
        idx = 0;
        
        task_mat = zeros(2,3); % place to store the data
        for r = 1:length(run_names)
            run_name = run_names{r};
            
            % Missing functional data for
            % 668361 RL WM
            
            % Missing EV files for
            % re-running 317332 LR SOCIAL
            % re-running 317332 RL SOCIAL
            if subnum == 668361 && strcmp(run_name,'RL') && strcmp(task,'WM')
                abs_mean  = NaN;
                rel_mean  = NaN;
                pct_bad = NaN;
            elseif subnum == 317332 && strcmp(task,'SOCIAL')
                abs_mean  = NaN;
                rel_mean  = NaN;
                pct_bad = NaN;
            else
                datadir = fullfile(maindatadir,'data',num2str(subnum),'MNINonLinear','Results',['tfMRI_' task '_' run_name]);
                abs_mean = load(fullfile(datadir,'Movement_AbsoluteRMS_mean.txt'));
                rel_mean = load(fullfile(datadir,'Movement_RelativeRMS_mean.txt'));
                
                fsldir = fullfile(maindatadir,'fsl',num2str(subnum),'MNINonLinear','Results',['tfMRI_' task '_' run_name]);
                motion_ICs_f = fullfile(fsldir,'smoothing.feat','ICA_AROMA','classified_motion_ICs.txt');
                motion_ICs = load(motion_ICs_f);
                n_bad = length(motion_ICs);
                melodic_mix_f = fullfile(fsldir,'smoothing.feat','ICA_AROMA','melodic.ica','melodic_mix');
                melodic_mix = load(melodic_mix_f);
                total = size(melodic_mix,2);
                pct_bad = n_bad / total;
            end
            
            fprintf(fid1,'%d,%s,%s,%f,%f,%f\n',subnum,task,run_name,abs_mean,rel_mean,pct_bad);
            
            task_mat(r,1) = abs_mean;
            task_mat(r,2) = rel_mean;
            task_mat(r,3) = pct_bad;
            
        end
        fprintf(fid2,'%d,%f,%f,%f\n',subnum,nanmean(task_mat));
        sub_data(s,:,t) = nanmean(task_mat);
    end
    fclose(fid2);
end
fclose(fid1);

sub_means = nanmean(sub_data,3);
outliers = isoutlier(sub_means,'quartiles');
outliers = any(outliers,2);
fname = fullfile(basedir,'headmotion_TaskAvg_LT.csv');
fid = fopen(fname,'w');
fprintf(fid,'subj,exclude,abs_mean,rel_mean,pct_removed\n');
for s = 1:length(subs)
    subnum = subs(s);
    fprintf(fid,'%d,%d,%f,%f,%f\n',subnum,outliers(s),sub_means(s,:));
end
fclose(fid);