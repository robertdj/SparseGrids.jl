C Output from Public domain Ratfor, version 1.0
      subroutine locn(i,j,kj,nadj,madj,x,y,ntot,eps)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      logical before
      n = nadj(i,0)
      if(n.eq.0)then
      kj = 1
      return
      endif
      do23002 ks = 1,n 
      kj = ks
      k = nadj(i,kj)
      call acchk(i,j,k,before,x,y,ntot,eps)
      if(before)then
      km = kj-1
      if(km.eq.0)then
      km = n
      endif
      k = nadj(i,km)
      call acchk(i,j,k,before,x,y,ntot,eps)
      if(before)then
      goto 23002
      endif
      if(kj.eq.1)then
      kj = n+1
      endif
      return
      endif
23002 continue
23003 continue
      if(before)then
      kj = 1
      else
      kj = n+1
      endif
      return
      end
