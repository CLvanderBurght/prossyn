%%% second level
% 01.12.2016
% used for revision 11.12.2018
% by Stan

clear

SPM_dir             = (['/nobackup/saar3/spm12/']);
Exp_dir             = (['/nobackup/saar3/fmri_analysis/']);
fstlvl_dir          = (['normalglm_newpreproc_170202_symm_br_newGLM_181210/']);
fstlvl_dir_flip     = (['normalglm_newpreproc_170202_symm_br_newGLM_181210_flipped/']);
output_dir_base     = (['/nobackup/saar3/fmri_analysis/secondlevel/lateral_test_paired_ttest_newGLM_181211']);

% 1leven con images: 10 = 4>5; 13 = 2>6; 08 = 5>4 (grammOnly); 11 = 1>3
% (prosOnly);14 = 6>2 (superfluous prosodic cue); 

current_con  = '11'; % 
contr_name   = '1vs3';

con_scans = {};

subj={'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38'};

% subs = {'01' '02' '03' '04' '06' '07' '08' '09' '10' '11' '13' '16' '17' '22' '23' '25' '26' '27' '28' '29' '30' '32' '34' '35' '36' '37'};

no_of_conds = 6;

parts = [1:4 6:11 13 16:17 22:23 25:30 32 34:37]; % 26 aprticipants left


output_dir          = [output_dir_base '/' contr_name];

for s = 1:length(parts) % loops through subjects 
    
    vp=parts(s);    
    % first the normal con images
        clear level1_dir tmpfile  
        level1_dir = ([Exp_dir 'vp' subj{vp} '/stats/' fstlvl_dir 'con_00' current_con '.nii']);

        tmpfile = dir(level1_dir);

        con_scans{1,s} = ([Exp_dir 'vp' subj{vp} '/stats/' fstlvl_dir tmpfile.name]);

    
    % the flipped con images
        clear level1_dir tmpfile  
        level1_flip_dir = ([Exp_dir 'vp' subj{vp} '/stats/' fstlvl_dir_flip 'con_00' current_con '*flipped.nii']);

        tmpfile = dir(level1_flip_dir);

        con_scans{2,s} = ([Exp_dir 'vp' subj{vp} '/stats/' fstlvl_dir_flip tmpfile.name]);

end

%%

matlabbatch{1}.spm.stats.factorial_design.dir = {output_dir};
for i = 1:length(parts)
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans(1,1) = con_scans(1,i);
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans(2,1) = con_scans(2,i);
end

matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'L>R';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

spm_jobman('run',matlabbatch);

