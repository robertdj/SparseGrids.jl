C Output from Public domain Ratfor, version 1.0
      subroutine stoke(x1,y1,x2,y2,rw,area,s1,eps,nerror)
      implicit double precision(a-h,o-z)
      dimension rw(4)
      logical value
      zero = 0.d0
      nerror = -1
      call testeq(x1,x2,eps,value)
      if(value)then
      area = 0.
      s1 = 0.
      return
      endif
      if(x1.lt.x2)then
      xl = x1
      yl = y1
      xr = x2
      yr = y2
      s1 = -1.
      else
      xl = x2
      yl = y2
      xr = x1
      yr = y1
      s1 = 1.
      endif
      xmin = rw(1)
      xmax = rw(2)
      ymin = rw(3)
      ymax = rw(4)
      slope = (yl-yr)/(xl-xr)
      x = max(xl,xmin)
      y = yl+slope*(x-xl)
      xl = x
      yl = y
      x = min(xr,xmax)
      y = yr+slope*(x-xr)
      xr = x
      yr = y
      if(xr.le.xmin.or.xl.ge.xmax)then
      area = 0.
      return
      endif
      ybot = min(yl,yr)
      ytop = max(yl,yr)
      if(ymax.le.ybot)then
      area = (xr-xl)*(ymax-ymin)
      return
      endif
      if(ymin.le.ybot.and.ymax.le.ytop)then
      call testeq(slope,zero,eps,value)
      if(value)then
      w1 = 0.
      w2 = xr-xl
      else
      xit = xl+(ymax-yl)/slope
      w1 = xit-xl
      w2 = xr-xit
      if(slope.lt.0.)then
      tmp = w1
      w1 = w2
      w2 = tmp
      endif
      endif
      area = 0.5*w1*((ybot-ymin)+(ymax-ymin))+w2*(ymax-ymin)
      return
      endif
      if(ybot.le.ymin.and.ymax.le.ytop)then
      xit = xl+(ymax-yl)/slope
      xib = xl+(ymin-yl)/slope
      if(slope.gt.0.)then
      w1 = xit-xib
      w2 = xr-xit
      else
      w1 = xib-xit
      w2 = xit-xl
      endif
      area = 0.5*w1*(ymax-ymin)+w2*(ymax-ymin)
      return
      endif
      if(ymin.le.ybot.and.ytop.le.ymax)then
      area = 0.5*(xr-xl)*((ytop-ymin)+(ybot-ymin))
      return
      endif
      if(ybot.le.ymin.and.ymin.le.ytop)then
      call testeq(slope,zero,eps,value)
      if(value)then
      area = 0.
      return
      endif
      xib = xl+(ymin-yl)/slope
      if(slope.gt.0.)then
      w = xr-xib
      else
      w = xib-xl
      endif
      area = 0.5*w*(ytop-ymin)
      return
      endif
      if(ytop.le.ymin)then
      area = 0.
      return
      endif
      nerror = 8
      return
      end
