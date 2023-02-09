%% Alamode-CP2K port, designed by Ruilin Mao, ICQM, Peking University
% email: mrlvip@163.com, to generate displaced CP2K input files for alamode
%% read xyzfiles
xyzfl= fileread("GaN_0.xyz");
AA = regexp(xyzfl, '\r\n|\r|\n', 'split');
cc=str2double(cellstr(AA{1}));
coordlst=zeros(cc,3);
numcell=cell(cc,1);
angsperbohr=0.52917721092;
amp=0.01;
vc1= [6.4643049841        0.0000000000        0.0000000000];
vc2= [3.2321524920        5.5982523340        0.0000000000];
vc3= [0.0000000000        0.0000000000       40.8555098589];
bs1= vc1/sqrt(sum(vc1.^2));
bs2= vc2/sqrt(sum(vc2.^2));
bs3= vc3/sqrt(sum(vc3.^2));
for i=1:cc
    spltcoordlst=regexp(AA{i+2},' *','split');
    numcell{i}=spltcoordlst{1};
    coordlst(i,1)=str2double(spltcoordlst{2});
    coordlst(i,2)=str2double(spltcoordlst{3});
    coordlst(i,3)=str2double(spltcoordlst{4});       
end
%% read (an)harmonic parameters
str = fileread("config_GaN");
A = regexp(str, '\r\n|\r|\n', 'split');
item=find(contains(A ,':'));
groupnum=length(item);
itemnum=[];
% displace the atom according to configuration files
formatspec='displace%d.xyz';
coordspc='%s  %f  %f  %f\n';
for i=1:groupnum
    spltstr=regexp(A{item(i)},':','split');
    itemnum=str2double(spltstr{2});
    codtemp=coordlst;
    for j=1:itemnum
        spltcoord=regexp(A{item(i)+j},' *','split');
        atomnum=str2double(spltcoord{2});
        temp=str2double(spltcoord{3})*bs1+str2double(spltcoord{4})*bs2+str2double(spltcoord{5})*bs3;
        codtemp(atomnum,:)=amp*temp+codtemp(atomnum,:);
    end
    filenamen=sprintf(formatspec,i);
    filid=fopen(filenamen,"w");
    fprintf(filid,'%d\n',cc);
    fprintf(filid,'\n');
    for k=1:cc
        fprintf(filid,coordspc,numcell{k},codtemp(k,1),codtemp(k,2),codtemp(k,3));
    end
    fclose(filid);
end
%% generate of CP2K input file
cpcode= fileread("OTgn.inp");
cdd = regexp(cpcode, '\r\n|\r|\n', 'split');
item1=find(contains(cdd,'PROJECT'));
item2=find(contains(cdd,'COORD_FILE_NAME'));
item3=find(contains(cdd,'FILENAME'));
filespec='OT%d.inp';
formatspec0='PROJECT OT%d';
formatspec1='COORD_FILE_NAME displace%d.xyz';
formatspec2='FILENAME =ff%d.fc';
formspecs='%s\n';
[~,fh]=size(cdd);
for i=1:groupnum
    filenamen=sprintf(filespec,i);
    filid=fopen(filenamen,"w");
    cdd{item1}=sprintf(formatspec0,i);
    cdd{item2}=sprintf(formatspec1,i);
    cdd{item3(2)}=sprintf(formatspec2,i);
    for h=1:fh
        fprintf(filid,formspecs,cdd{h});
    end
    fclose(filid);
end
