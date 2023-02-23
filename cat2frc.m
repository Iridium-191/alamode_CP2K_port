%% read xyzfiles
xyzfl= fileread("graphene.xyz");
AA = regexp(xyzfl, '\r\n|\r|\n', 'split');
cc=str2double(cellstr(AA{1}));
coordlst=zeros(cc,3);
numcell=cell(cc,1);
angsperbohr=0.52917721092;
amp=0.01;
for i=1:cc
    spltcoordlst=regexp(AA{i+2},' *','split');
    numcell{i}=spltcoordlst{1};
    coordlst(i,1)=str2double(spltcoordlst{3});
    coordlst(i,2)=str2double(spltcoordlst{4});
    coordlst(i,3)=str2double(spltcoordlst{5});       
end
%% Cell parameters
vc1= [12.2325000763         0.0000000000         0.0000000000];
vc2= [-6.1162500381        10.5936558179         0.0000000000];
vc3= [ 0.0000000000         0.0000000000        20.0000000000];
celltmp=[vc1;vc2;vc3];
fraccoord=zeros(cc,3);
for i=1:cc
    fraccoord(i,:)=coordlst(i,:)/celltmp;
end
filenamen='grapheneFRAC';
filid=fopen(filenamen,"w");
coordspec='%s  %.16f  %.16f  %.16f\n';
for k=1:cc
    fprintf(filid,coordspec,numcell{k},fraccoord(k,1),fraccoord(k,2),fraccoord(k,3));
end
fclose(filid);