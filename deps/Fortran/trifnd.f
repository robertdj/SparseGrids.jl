C Output from Public domain Ratfor, version 1.0
      subroutine trifnd(j,tau,nedge,nadj,madj,x,y,ntot,eps,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot), xt(3), yt(
     *3)
      integer tau(3), temp(21)
      logical adjace
      nerror = -1
      if(j.eq.1)then
      nerror = 11
      return
      endif
      j1 = j-1
      tau(1) = j1
      tau(3) = nadj(j1,1)
      call pred(tau(2),j1,tau(3),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call adjchk(tau(2),tau(3),adjace,nadj,madj,ntot,nerror)
      if(nerror.gt.0)then
      return
      endif
      if(.not.adjace)then
      tau(3) = tau(2)
      call pred(tau(2),j1,tau(3),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      endif
1     continue
      ntau = 0
      nedge = 0
      do23010 i = 1,3 
      ip = i+1
      if(ip.eq.4)then
      ip = 1
      endif
      xt(1) = x(tau(i))
      yt(1) = y(tau(i))
      xt(2) = x(tau(ip))
      yt(2) = y(tau(ip))
      xt(3) = x(j)
      yt(3) = y(j)
      if(tau(i).le.0)then
      i1 = 1
      else
      i1 = 0
      endif
      if(tau(ip).le.0)then
      j1 = 1
      else
      j1 = 0
      endif
      k1 = 0
      ijk = i1*4+j1*2+k1
      call cross(xt,yt,ijk,cprd)
      if(cprd .ge. eps)then
      continue
      else
      if(cprd .gt. -eps)then
      nedge = ip
      else
      ntau = ip
      goto 23011
      endif
      endif
23010 continue
23011 continue
      if(ntau.eq.0)then
      return
      endif
      if(ntau.eq.1)then
      tau(2) = tau(3)
      call succ(tau(3),tau(1),tau(2),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      endif
      if(ntau.eq.2)then
      tau(3) = tau(2)
      call pred(tau(2),tau(1),tau(3),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      endif
      if(ntau.eq.3)then
      tau(1) = tau(3)
      call succ(tau(3),tau(1),tau(2),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      endif
      go to 1
      end
