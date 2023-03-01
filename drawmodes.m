%% Draw phonon modes in format of .axsf
%% Designed by Ruilin Mao, ICQM, Peking University, email: mrlvip@163.com, all rights reserved.
%% read axsf files
axsfile=fileread("GaN_anhrm_7_3br.axsf");
AA=regexp(axsfile,'\r\n|\r|\n', 'split');
angsperbohr=0.52917721092;
spltemp=regexp(AA{1},' *','split');
modenum=str2double(spltemp{2});
spltemp=regexp(AA{4},' *','split');
vc1=[str2double(spltemp{2}) str2double(spltemp{3}) str2double(spltemp{4})];
spltemp=regexp(AA{5},' *','split');
vc2=[str2double(spltemp{2}) str2double(spltemp{3}) str2double(spltemp{4})];
spltemp=regexp(AA{6},' *','split');
vc3=[str2double(spltemp{2}) str2double(spltemp{3}) str2double(spltemp{4})];
species{1}='Ga';
species{2}='N';
%% Match mode paragraphs
title=find(contains(AA,'PRIMCOORD'));
spltemp=regexp(AA{title(1)+1},' *','split');
atomnum=str2double(spltemp{2});
coord=zeros(atomnum,3);
element=zeros(atomnum,1);
for i=1:atomnum
   spltemp=regexp(AA{title(1)+1+i},' *','split');
   for c=1:length(species)
       if spltemp{2}==species{c}
           element(i)=c;
       end
   end
   coord(i,1)=str2double(spltemp{3});
   coord(i,2)=str2double(spltemp{4});
   coord(i,3)=str2double(spltemp{5});
   eigvec=coord(i,:)/[vc1;vc2;vc3];
   %% 
   egc=floor(eigvec);
   coord(i,:)=coord(i,:)-egc(1)*vc1-egc(2)*vc2-egc(3)*vc3;
end
%% grep the eigenvectors
evec=zeros(modenum,atomnum,3);
for i=1:modenum
    for j=1:atomnum
        spltemp=regexp(AA{title(i)+1+j},' *','split');
        evec(i,j,1)=str2double(spltemp{6});
        evec(i,j,2)=str2double(spltemp{7});
        evec(i,j,3)=str2double(spltemp{8});
    end
end
%% plot the eigenvectors
flag=0;
coordnw=zeros(125*atomnum,3);
evcnw=zeros(125*atomnum,3);
evecnw=zeros(modenum,125*atomnum,3);
typenw=zeros(125*atomnum,1);
for i=1:5
    for j=1:5
        for k=1:5
            flag=flag+1;
            f1=(flag-1)*atomnum+1;
            f2=flag*atomnum;
            coordnw(f1:f2,:)=coord+i*vc1+j*vc2+k*vc3;
            evecnw(:,f1:f2,:)=evec;
            typenw(f1:f2)=element;
        end
    end
end
fdcw=[];
for i=1:125*atomnum
    evcnw=coordnw(i,:)/[vc1;vc2;vc3];
    if evcnw(1) > 1.99 && evcnw(1) < 3.01 && evcnw(2) > 1.99 && evcnw(2) < 3.01 && evcnw(3) > 1.99 && evcnw(3) < 3.01
        fdcw=[fdcw;i];
    end
end
coordfw=coordnw(fdcw,:)-2*vc1-2*vc2-2*vc3;
evecfw=evecnw(:,fdcw,:);
typefw=typenw(fdcw);
%% draw plots
for i=1:modenum
    f=figure(i);
    f.Position=[100+10*i,200,1024,1024];
    hold on;
    axis([-2,max(vc1(1)+vc2(1)+vc3(1))+2,-2,max(vc1(2)+vc2(2)+vc3(2))+2,-2,max(vc1(3)+vc2(3)+vc3(3))+2]);
    plot3([0,vc1(1)],[0,vc1(2)],[0,vc1(3)],'k');
    plot3([0,vc2(1)],[0,vc2(2)],[0,vc2(3)],'k');
    plot3([0,vc3(1)],[0,vc3(2)],[0,vc3(3)],'k');
    plot3([vc3(1),vc3(1)+vc1(1)],[vc3(2),vc3(2)+vc1(2)],[vc3(3),vc3(3)+vc1(3)],'k');
    plot3([vc3(1),vc3(1)+vc2(1)],[vc3(2),vc3(2)+vc2(2)],[vc3(3),vc3(3)+vc2(3)],'k');
    plot3([vc2(1),vc3(1)+vc2(1)],[vc2(2),vc3(2)+vc2(2)],[vc2(3),vc3(3)+vc2(3)],'k');
    plot3([vc1(1),vc3(1)+vc1(1)],[vc1(2),vc3(2)+vc1(2)],[vc1(3),vc3(3)+vc1(3)],'k');
    plot3([vc3(1)+vc1(1),vc3(1)+vc1(1)+vc2(1)],[vc3(2)+vc1(2),vc3(2)+vc1(2)+vc2(2)],[vc3(3)+vc1(3),vc3(3)+vc1(3)+vc2(3)],'k');
    plot3([vc3(1)+vc2(1),vc3(1)+vc1(1)+vc2(1)],[vc3(2)+vc2(2),vc3(2)+vc1(2)+vc2(2)],[vc3(3)+vc2(3),vc3(3)+vc1(3)+vc2(3)],'k');
    plot3([vc1(1),vc1(1)+vc2(1)],[vc1(2),vc1(2)+vc2(2)],[vc1(3),vc1(3)+vc2(3)],'k');
    plot3([vc2(1),vc1(1)+vc2(1)],[vc2(2),vc1(2)+vc2(2)],[vc2(3),vc1(3)+vc2(3)],'k');
    plot3([vc1(1)+vc2(1),vc3(1)+vc1(1)+vc2(1)],[vc1(2)+vc2(2),vc3(2)+vc1(2)+vc2(2)],[vc2(3)+vc1(3),vc3(3)+vc1(3)+vc2(3)],'k');
    ac=find(typefw==1);
    scatter3(coordfw(ac,1),coordfw(ac,2),coordfw(ac,3),200,[0.25 0.5 0.5],'filled');
    ad=find(typefw==2);
    scatter3(coordfw(ad,1),coordfw(ad,2),coordfw(ad,3),100,[1 0.5 0],'filled');
    qv1=squeeze(evecfw(i,:,1));
    qv2=squeeze(evecfw(i,:,2));
    qv3=squeeze(evecfw(i,:,3));
    quiver3(coordfw(:,1),coordfw(:,2),coordfw(:,3),qv1',qv2',qv3');
    pause(0.1)
end
