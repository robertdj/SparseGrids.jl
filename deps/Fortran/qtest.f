C Output from Public domain Ratfor, version 1.0
      subroutine qtest(h,i,j,k,shdswp,x,y,ntot,eps,nerror)
      implicit double precision(a-h,o-z)
      dimension x(-3:ntot), y(-3:ntot)
      integer h
      logical shdswp
      nerror = -1
      if(i.le.0)then
      ii = 1
      else
      ii = 0
      endif
      if(j.le.0)then
      jj = 1
      else
      jj = 0
      endif
      if(k.le.0)then
      kk = 1
      else
      kk = 0
      endif
      ijk = ii*4+jj*2+kk
      if(ijk.eq.7)then
      shdswp = .true.
      return
      endif
      if(ijk.eq.6)then
      xh = x(h)
      yh = y(h)
      xk = x(k)
      yk = y(k)
      ss = 1 - 2*mod(-j,2)
      test = (xh*yk+xk*yh-xh*yh-xk*yk)*ss
      if(test.gt.0.d0)then
      shdswp = .true.
      else
      shdswp = .false.
      endif
      if(shdswp)then
      call acchk(j,k,h,shdswp,x,y,ntot,eps)
      endif
      return
      endif
      if(ijk.eq.5)then
      shdswp = .true.
      return
      endif
      if(ijk.eq.4)then
      call acchk(j,k,h,shdswp,x,y,ntot,eps)
      return
      endif
      if(ijk.eq.3)then
      xi = x(i)
      yi = y(i)
      xh = x(h)
      yh = y(h)
      ss = 1 - 2*mod(-j,2)
      test = (xh*yi+xi*yh-xh*yh-xi*yi)*ss
      if(test.gt.0.d0)then
      shdswp = .true.
      else
      shdswp = .false.
      endif
      if(shdswp)then
      call acchk(h,i,j,shdswp,x,y,ntot,eps)
      endif
      return
      endif
      if(ijk.eq.2)then
      shdswp = .false.
      return
      endif
      if(ijk.eq.1)then
      call acchk(h,i,j,shdswp,x,y,ntot,eps)
      return
      endif
      if(ijk.eq.0)then
      call qtest1(h,i,j,k,x,y,ntot,eps,shdswp,nerror)
      return
      endif
      nerror = 7
      return
      end
