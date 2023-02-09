str = fileread("config_GaN");
A = regexp(str, '\r\n|\r|\n', 'split');
item=find(contains(A ,':'));
groupnum=length(item);
angsperbohr=0.52917721092;
itemnum=[];
formatspec='displace%d.xyz';
fcspc=' %f  %f  %f  %f  %f  %f\n';
filefcn='DFSET_harm';
filid=fopen(filefcn,"w");
cc=128;
amp=0.01;
vc1= [6.4643049841        0.0000000000        0.0000000000];
vc2= [3.2321524920        5.5982523340        0.0000000000];
vc3= [0.0000000000        0.0000000000       40.8555098589];
bs1= vc1/mod(vc1);
bs2= vc1/mod(bs2);
bs3= vc3/mod(vc3);
for i=1:groupnum
    spltstr=regexp(A{item(i)},':','split');
    itemnum=str2double(spltstr{2});
    codtemp=zeros(cc,3);
    for j=1:itemnum
        spltcoord=regexp(A{item(i)+j},' *','split');
        atomnum=str2double(spltcoord{2});
        temp=[str2double(spltcoord{3}) str2double(spltcoord{4}) str2double(spltcoord{5})];
        codtemp(atomnum,:)=amp*temp/angsperbohr+codtemp(atomnum,:);
    end
    fcfln=sprintf('ff%d.fc',i);    
    fcfl= fileread(fcfln);
    AA = regexp(fcfl, '\r\n|\r|\n', 'split');
    fclst=zeros(cc,3);
    for jj=1:cc
        spltcoordlst=regexp(AA{jj+4},' *','split');
        fclst(jj,1)=str2double(spltcoordlst{5})*2;
        fclst(jj,2)=str2double(spltcoordlst{6})*2;
        fclst(jj,3)=str2double(spltcoordlst{7})*2;    
    end
    fprintf(filid,'#Displacement and force of group %d\n',i);
    for k=1:cc
        fprintf(filid,fcspc,codtemp(k,1),codtemp(k,2),codtemp(k,3),fclst(k,1),fclst(k,2),fclst(k,3));
    end
end
fclose(filid);