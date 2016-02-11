C Output from Public domain Ratfor, version 1.0
      subroutine testeq(a,b,eps,value)
      implicit double precision(a-h,o-z)
      logical value
      one = 1.d0
      ten = 1.d10
      if(abs(b).le.eps)then
      if(abs(a).le.eps)then
      value = .true.
      else
      value = .false.
      endif
      return
      endif
      if(abs(a).gt.ten*abs(b).or.abs(a).lt.one*abs(b))then
      value = .false.
      return
      endif
      c = a/b
      if(abs(c-1.d0).le.eps)then
      value = .true.
      else
      value = .false.
      endif
      return
      end
