C Output from Public domain Ratfor, version 1.0
      subroutine mnnd(x,y,n,dminbig,dminav)
      implicit double precision(a-h,o-z)
      dimension x(n), y(n)
      dminav = 0.d0
      do23000 i = 1,n 
      dmin = dminbig
      do23002 j = 1,n 
      if(i.ne.j)then
      d = (x(i)-x(j))**2 + (y(i)-y(j))**2
      if(d .lt. dmin)then
      dmin = d
      endif
      endif
23002 continue
23003 continue
      dminav = dminav + sqrt(dmin)
23000 continue
23001 continue
      dminav = dminav/n
      return
      end
