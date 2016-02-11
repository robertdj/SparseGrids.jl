C Output from Public domain Ratfor, version 1.0
      subroutine initad(j,nadj,madj,x,y,ntot,eps,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      integer tau(3)
      call trifnd(j,tau,nedge,nadj,madj,x,y,ntot,eps,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(nedge.ne.0)then
      ip = nedge
      i = ip-1
      if(i.eq.0)then
      i = 3
      endif
      call pred(k,tau(i),tau(ip),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call succ(kk,tau(ip),tau(i),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call delet(tau(i),tau(ip),nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(k.eq.kk)then
      call insrt(j,k,nadj,madj,x,y,ntot,nerror,eps)
      endif
      if(nerror .gt. 0)then
      return
      endif
      endif
      do23016 i = 1,3 
      call insrt(j,tau(i),nadj,madj,x,y,ntot,nerror,eps)
      if(nerror .gt. 0)then
      return
      endif
23016 continue
23017 continue
      return
      end
