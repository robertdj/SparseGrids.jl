C Output from Public domain Ratfor, version 1.0
      subroutine dldins(a,b,slope,rwu,ai,bi,rw,intfnd,bpt)
      implicit double precision(a-h,o-z)
      dimension rw(4)
      logical intfnd, bpt, rwu
      intfnd = .true.
      bpt = .true.
      xmin = rw(1)
      xmax = rw(2)
      ymin = rw(3)
      ymax = rw(4)
      if(xmin.le.a.and.a.le.xmax.and.ymin.le.b.and.b.le.ymax)then
      ai = a
      bi = b
      bpt = .false.
      return
      endif
      if(.not.rwu)then
      if(b .lt. ymin)then
      ai = a
      bi = ymin
      if(xmin.le.ai.and.ai.le.xmax)then
      return
      endif
      endif
      if(b .gt. ymax)then
      ai = a
      bi = ymax
      if(xmin.le.ai.and.ai.le.xmax)then
      return
      endif
      endif
      intfnd = .false.
      return
      endif
      if(a.lt.xmin)then
      ai = xmin
      bi = b + slope*(ai-a)
      if(ymin.le.bi.and.bi.le.ymax)then
      return
      endif
      endif
      if(b.lt.ymin)then
      bi = ymin
      ai = a + (bi-b)/slope
      if(xmin.le.ai.and.ai.le.xmax)then
      return
      endif
      endif
      if(a.gt.xmax)then
      ai = xmax
      bi = b + slope*(ai-a)
      if(ymin.le.bi.and.bi.le.ymax)then
      return
      endif
      endif
      if(b.gt.ymax)then
      bi = ymax
      ai = a + (bi-b)/slope
      if(xmin.le.ai.and.ai.le.xmax)then
      return
      endif
      endif
      intfnd = .false.
      return
      end
