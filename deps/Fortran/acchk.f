C Output from Public domain Ratfor, version 1.0
      subroutine acchk(i,j,k,anticl,x,y,ntot,eps)
      implicit double precision(a-h,o-z)
      dimension x(-3:ntot), y(-3:ntot), xt(3), yt(3)
      logical anticl
      if(i.le.0)then
      i1 = 1
      else
      i1 = 0
      endif
      if(j.le.0)then
      j1 = 1
      else
      j1 = 0
      endif
      if(k.le.0)then
      k1 = 1
      else
      k1 = 0
      endif
      ijk = i1*4+j1*2+k1
      xt(1) = x(i)
      yt(1) = y(i)
      xt(2) = x(j)
      yt(2) = y(j)
      xt(3) = x(k)
      yt(3) = y(k)
      call cross(xt,yt,ijk,cprd)
      if(cprd .gt. eps)then
      anticl = .true.
      else
      anticl = .false.
      endif
      return
      end
