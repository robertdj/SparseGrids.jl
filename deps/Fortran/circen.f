C Output from Public domain Ratfor, version 1.0
      subroutine circen(i,j,k,x0,y0,x,y,ntot,eps,collin,nerror)
      implicit double precision(a-h,o-z)
      dimension x(-3:ntot), y(-3:ntot), xt(3), yt(3)
      logical collin
      nerror = -1
      xt(1) = x(i)
      yt(1) = y(i)
      xt(2) = x(j)
      yt(2) = y(j)
      xt(3) = x(k)
      yt(3) = y(k)
      ijk = 0
      call cross(xt,yt,ijk,cprd)
      if(abs(cprd) .lt. eps)then
      collin = .true.
      else
      collin = .false.
      endif
      a = x(j) - x(i)
      b = y(j) - y(i)
      c = x(k) - x(i)
      d = y(k) - y(i)
      c1 = sqrt(a*a+b*b)
      c2 = sqrt(c*c+d*d)
      a = a/c1
      b = b/c1
      c = c/c2
      d = d/c2
      if(collin)then
      alpha = a*c+b*d
      if(alpha.gt.0)then
      nerror = 3
      return
      endif
      return
      endif
      crss = a*d - b*c
      x0 = x(i) + 0.5*(c1*d - c2*b)/crss
      y0 = y(i) + 0.5*(c2*a - c1*c)/crss
      return
      end
