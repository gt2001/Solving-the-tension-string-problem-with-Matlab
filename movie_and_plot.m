h=0.3;
l=1.0;
c=1;a=0;f=0;d=1;

g='squareg'
[p,e,t]=initmesh(g);
[p,e,t]=refinemesh(g,p,e,t);

x=p(1,:)';
y=p(2,:)';
u0=6*h/l*x.*(x>=0&x<=l/6)+6*h/l/5*(l-x).*(x>l/6&x<=l);
ut0=0;
n=31;
tlist=linspace(0,5,n);
uu=hyperbolic(u0,ut0,tlist,'squareb3',p,e,t,1,0,0,1);
pdeplot(p,e,t,'xydata',uu,'zdata',uu,'mesh','off')
delta=0:0.05:1;
[uxy,tn,a2,a3]=tri2grid(p,t,uu(:,1),delta,delta);
gp=[tn;a2;a3];
np=newplot;hf=get(np,'parent');
M=moviein(n,hf);
umax=max(max(uu));
umin=min(min(uu));
for i=1:n,
pdeplot(p,e,t,'xydata',uu(:,i),'zdata',uu(:,i),...
'mesh','on','xygrid','on','gridparam',gp,...
'colorbar','off','zstyle','continuous');
axis([0 1 0 1 umin umax]);caxis([umin umax]);
M(:,i)=getframe;
end

out = VideoWriter('out.avi');
out.FrameRate = 10;
open(out);
writeVideo(out,M);
close(out);

range=0.001;
temp=find(p(l,:) - 0.3 < range & p(l,:) - 0.3 > -range);
temp=temp(1);
x2=0.3;
t=tlist;
y2=72*h/5/(pi^2)* (1/2*sin (pi*x2/l)*cos(c*pi/l*t) +0.866/4*sin (2*pi*x2/l)*cos (2*c*pi/l*t) +1/9 *sin(3*pi*x2/l)*cos(3*c*pi/l*t));
figure(3);
plot(t,uu(temp,:),t,y2)
legend('数值解','理论解')