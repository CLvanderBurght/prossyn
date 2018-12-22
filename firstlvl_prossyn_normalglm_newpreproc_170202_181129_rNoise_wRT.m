    %-----------------------------------------------------------------------
% First Level Analysis - LNGPW - Normal GLM
%-----------------------------------------------------------------------

%%%%% start MATLAB as matlab -v 7.14 -nodisplay
%%%%% addpath ('Directory_of_current_script')s

clear

SPM_dir = (['/nobackup/saar3/spm12/']);
Exp_dir = (['/nobackup/saar3/fmri_analysis/']);
Img_dir = (['/nobackup/saar3/fmri_analysis_canon/']);
Anlys_type = (['normalglm_181129_regRTs_regNoise']); 
Anlys_type_outp = (['normalglm_newpreproc_170202_181204_rNoise_withLogRTs']); 

%	addpath(SPM_dir);
%	spm('defaults', 'FMRI');
%	spm_jobman('initcfg');


subj={'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38'};

for s =   [2:4 6:11 13 16:17 22:23 25:30 32 34:37]  %1:length(subj)
    
    clear dataPRP SourceDir
    SourceDir = ([Img_dir 'vp' subj{s} '/func/s3w3*.nii']); % why does Tom??s use s*.nii files? <- fab 20161124
    files ={};
    files = dir(SourceDir);
    for i = 1:1:1590
        dataPRP{i,1} = ([Img_dir 'vp' subj{s} '/func/' files(i,1).name]);
    end
        
    clear dataCND SourceDir
    SourceDir = ([Exp_dir 'genjobs/conditions/' Anlys_type '/conditions_vp' subj{s} '_regNOISE.mat']);
    files ={};
    files = dir(SourceDir);
    dataCND{1,1} = ([Exp_dir 'genjobs/conditions/' Anlys_type '/' files(1,1).name]);    
        
    clear fileR
    fileR{1,1} = ([Exp_dir 'vp' subj{s} '/stats/' Anlys_type_outp '/RTparamMod_' subj{s} '.mat']);
    
    clear fileSTA
    fileSTA{1,1} = ([Exp_dir 'vp' subj{s} '/stats/' Anlys_type_outp '/']);

if exist(fileSTA{1,1})==0
	mkdir(fileSTA{1,1})
end

matlabbatch{1}.spm.stats.fmri_spec.dir = {fileSTA{1,1}};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 30; % when slice-time correction used: number of slices
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 30; % match to reference slice!  
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = dataPRP(:,1);
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {dataCND{:,1}};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {fileR{:,1}};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None'; % why is there no matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8; ??
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)'; % autoregressive model
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
%matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
%matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
%matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
%matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
%matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
%matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
%matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
%matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = '11';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0 0]; % number of columns: 6 cons, 6 PMs, 6 RPs, 1 session constant
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = '12';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0 0 0]; % number of columns: 6 cons, 6 PMs, 6 RPs, 1 session constant
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = '21';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = '22';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = '31';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1 0 0 0];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = '32';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'noise';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [zeros(1,6) 1 0];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'RT_mod';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [zeros(1,6) 0 1];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = '22PM';
% matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [zeros(1,6) 0 1 0 0 0 0];
% matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
% 
% matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = '31';
% matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [zeros(1,6) 0 0 1 0 0 0];
% matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = '31PM';
% matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [zeros(1,6) 0 0 0 1 0 0];
% matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
% 
% matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = '32';
% matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [zeros(1,6) 0 0 0 0 1 0];
% matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = '32PM';
% matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [zeros(1,6) 0 0 0 0 0 1];
% matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
% 
% matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('run',matlabbatch);
disp(['___ Finished - first level with noise regressor and RT regressor VP' subj{s} '_rNOISE___']);
end

sendmail('vanderburght@cbs.mpg.de','End of SPM first level',['First level done  .'])
