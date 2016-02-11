C Output from Public domain Ratfor, version 1.0
      subroutine qtest1(h,i,j,k,x,y,ntot,eps,shdswp,nerror)
      implicit double precision(a-h,o-z)
      dimension x(-3:ntot), y(-3:ntot)
      integer h
      logical shdswp
      xh = x(h)
      yh = y(h)
      xj = x(j)
      yj = y(j)
      call circen(h,i,k,x0,y0,x,y,ntot,eps,shdswp,nerror)
      if(nerror.gt.0)then
      return
      endif
      if(shdswp)then
      return
      endif
      a = x0-xh
      b = y0-yh
      r2 = a*a+b*b
      a = x0-xj
      b = y0-yj
      ch = a*a + b*b
      if(ch.lt.r2)then
      shdswp = .true.
      else
      shdswp = .false.
      endif
      return
      end
