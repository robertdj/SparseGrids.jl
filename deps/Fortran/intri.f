C Output from Public domain Ratfor, version 1.0
      subroutine intri(x,y,u,v,n,okay)
      implicit double precision(a-h,o-z)
      dimension x(3), y(3), u(n), v(n)
      logical okay, inside
      zero = 0.d0
      s = 1.d0
      a = x(2) - x(1)
      b = y(2) - y(1)
      c = x(3) - x(1)
      d = y(3) - y(1)
      cp = a*d - b*c
      if(cp .lt. 0)then
      s = -s
      endif
      do23002 i = 1,n 
      inside = .true.
      do23004 j = 1,3 
      jp = j+1
      if(jp.eq.4)then
      jp = 1
      endif
      a = x(jp) - x(j)
      b = y(jp) - y(j)
      c = u(i) - x(j)
      d = v(i) - y(j)
      cp = s*(a*d - b*c)
      if(cp .le. zero)then
      inside = .false.
      goto 23005
      endif
23004 continue
23005 continue
      if(inside)then
      okay = .false.
      return
      endif
23002 continue
23003 continue
      okay = .true.
      return
      end
