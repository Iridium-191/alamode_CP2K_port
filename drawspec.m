%% Drawing of spectrum thermal conductivity map
tempframe=1000;
tempgap=10;
energyframe=700;
energygap=1;
specfl= fileread("GaN_anhrm_7_3br_pure.kl_spec");
AA = regexp(specfl, '\r\n|\r|\n', 'split');
tflag=0;
xxsp1=zeros(energyframe/energygap+1,tempframe/10+1);
yysp1=zeros(energyframe/energygap+1,tempframe/10+1);
zzsp1=zeros(energyframe/energygap+1,tempframe/10+1);
for i=1:(tempframe/10+1)
    lflag=0;
    for j=1:(energyframe/energygap+2)
        tflag=tflag+1;
        lflag=lflag+1;
        if lflag ~= 1
           splt=regexp(AA{tflag},' *','split');
           xxsp1(j,i)=str2double(splt{4});
           yysp1(j,i)=str2double(splt{5});
           zzsp1(j,i)=str2double(splt{6});     
        end
    end
end
%%
subplot(3,1,1)
imagesc([0,1000],[0,700],log10(xxsp));
title('\kappa_{xx}((log(W/(m·K)·cm))')
xlabel('Temperature (K)')
ylabel('Wavenumber (cm^{-1})')
colormap jet;
colorbar eastoutside;
subplot(3,1,2)
imagesc([0,1000],[0,700],log10(yysp));
title('\kappa_{yy}((log(W/(m·K)·cm))')
xlabel('Temperature (K)')
ylabel('Wavenumber (cm^{-1})')
colormap jet;
colorbar eastoutside;
subplot(3,1,3)
imagesc([0,1000],[0,700],log10(zzsp));
title('\kappa_{zz}((log(W/(m·K)·cm))')
xlabel('Temperature (K)')
ylabel('Wavenumber (cm^{-1})')
colormap jet;
colorbar eastoutside;
           