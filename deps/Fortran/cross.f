C Output from Public domain Ratfor, version 1.0
      subroutine cross(x,y,ijk,cprd)
      implicit double precision(a-h,o-z)
      dimension x(3), y(3)
      zero = 0.d0
      one = 1.d0
      two = 2.d0
      four = 4.d0
      if(ijk.eq.0)then
      smin = -one
      do23002 i = 1,3 
      ip = i+1
      if(ip.eq.4)then
      ip = 1
      endif
      a = x(ip) - x(i)
      b = y(ip) - y(i)
      s = a*a+b*b
      if(smin .lt. zero .or. s .lt. smin)then
      smin = s
      endif
23002 continue
23003 continue
      endif
      if(ijk.eq.1)then
      x(2) = x(2) - x(1)
      y(2) = y(2) - y(1)
      x(1) = zero
      y(1) = zero
      cn = sqrt(x(2)**2+y(2)**2)
      x(2) = x(2)/cn
      y(2) = y(2)/cn
      smin = one
      endif
      if(ijk.eq.2)then
      x(3) = x(3) - x(1)
      y(3) = y(3) - y(1)
      x(1) = zero
      y(1) = zero
      cn = sqrt(x(3)**2+y(3)**2)
      x(3) = x(3)/cn
      y(3) = y(3)/cn
      smin = one
      endif
      if(ijk.eq.3)then
      x(1) = zero
      y(1) = zero
      smin = 2
      endif
      if(ijk.eq.4)then
      x(3) = x(3) - x(2)
      y(3) = y(3) - y(2)
      x(2) = zero
      y(2) = zero
      cn = sqrt(x(3)**2+y(3)**2)
      x(3) = x(3)/cn
      y(3) = y(3)/cn
      smin = one
      endif
      if(ijk.eq.5)then
      x(2) = zero
      y(2) = zero
      smin = two
      endif
      if(ijk.eq.6)then
      x(3) = zero
      y(3) = zero
      smin = two
      endif
      if(ijk.eq.7)then
      smin = four
      endif
      a = x(2)-x(1)
      b = y(2)-y(1)
      c = x(3)-x(1)
      d = y(3)-y(1)
      cprd = (a*d - b*c)/smin
      return
      end
