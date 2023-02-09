%% read xyzfiles
xyzfl= fileread("GaN_0.xyz");
AA = regexp(xyzfl, '\r\n|\r|\n', 'split');
cc=str2double(cellstr(AA{1}));
coordlst=zeros(cc,3);
numcell=cell(cc,1);
angsperbohr=0.52917721092;
amp=0.01;
for i=1:cc
    spltcoordlst=regexp(AA{i+2},' *','split');
    numcell{i}=spltcoordlst{1};
    coordlst(i,1)=str2double(spltcoordlst{2});
    coordlst(i,2)=str2double(spltcoordlst{3});
    coordlst(i,3)=str2double(spltcoordlst{4});       
end
%% Cell parameters
vc1= [6.4643049841        0.0000000000        0.0000000000];
vc2= [3.2321524920        5.5982523340        0.0000000000];
vc3= [0.0000000000        0.0000000000       40.8555098589];
celltmp=[vc1;vc2;vc3];
fraccoord=zeros(cc,3);
for i=1:cc
    temp1=coordlst(i,:);
    temp1=temp1';
    temp2=celltmp\temp1;
    fraccoord(i,:)=temp2';
end
filenamen='GaNFRAC';
filid=fopen(filenamen,"w");
coordspec='%s  %f  %f  %f\n';
for k=1:cc
    fprintf(filid,coordspec,numcell{k},fraccoord(k,1),fraccoord(k,2),fraccoord(k,3));
end
fclose(filid);