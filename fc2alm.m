str = fileread("GaNINTER.pattern_ANHARM3");
A = regexp(str, '\r\n|\r|\n', 'split');
item=find(contains(A ,':'));
groupnum=length(item);
angsperbohr=0.52917721092;
itemnum=[];
formatspec='displace%d.xyz';
fcspc=' %.16f  %.16f  %.16f  %.16f  %.16f  %.16f\n';
filefcn='DFSET_anharm_GOPair';
filid=fopen(filefcn,"w");
cc=128;
amp=0.05;
vc1= [6.4643089007        0.0000000000        0.0000000000];
vc2= [3.2321544503        5.5982557259        0.0000000000];
vc3= [0.0000000000        0.0000000000       40.8557201963];
bs1= vc1/sqrt(sum(vc1.^2));
bs2= vc2/sqrt(sum(vc1.^2));
bs3= vc3/sqrt(sum(vc1.^2));
for i=1:groupnum
    spltstr=regexp(A{item(i)},':','split');
    itemnum=str2double(spltstr{2});
    codtemp=zeros(cc,3);
    for j=1:itemnum
        spltcoord=regexp(A{item(i)+j},' *','split');
        atomnum=str2double(spltcoord{2});
        temp=bs1*str2double(spltcoord{3})+bs2*str2double(spltcoord{4})+bs3*str2double(spltcoord{5});
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