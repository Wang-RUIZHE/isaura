
function [pc]=inter_seg(p1,p2,q1,q2)
corta=0;
punto=interseccion2d(p1,p2,q1,q2);
%nous verifions que le point appartienne au segment p1-p2
minX=min(p1(1),p2(1));
maxX=max(p1(1),p2(1));
minY=min(p1(2),p2(2));
maxY=max(p1(2),p2(2));
test1=precision(punto(1)-minX);
test2=precision(punto(1)-maxX);
test3=precision(punto(2)-minY);
test4=precision(punto(2)-maxY);
if (((punto(1)>minX) | (test1==0)) & ((punto(1)<maxX) | (test2==0)) & ((punto(2)>minY) | (test3==0)) & ((punto(2)<maxY) | (test4==0))) 
%nous verifions que le point appartienne au segment q1-q2
    minXBIS=min(q1(1),q2(1));
   maxXBIS=max(q1(1),q2(1));
    minYBIS=min(q1(2),q2(2));
    maxYBIS=max(q1(2),q2(2));
    test1BIS=precision(punto(1)-minXBIS);
    test2BIS=precision(punto(1)-maxXBIS);
    test3BIS=precision(punto(2)-minYBIS);
    test4BIS=precision(punto(2)-maxYBIS);    
    if (((punto(1)>minXBIS) | (test1BIS==0)) & ((punto(1)<maxXBIS) | (test2BIS==0)) & ((punto(2)>minYBIS) | (test3BIS==0)) & ((punto(2)<maxYBIS) | (test4BIS==0)))
        corta=1;
    end
end
pc=[punto,corta];   