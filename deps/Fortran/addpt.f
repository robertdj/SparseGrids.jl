C Output from Public domain Ratfor, version 1.0
      subroutine addpt(j,nadj,madj,x,y,ntot,eps,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      logical didswp
      call initad(j,nadj,madj,x,y,ntot,eps,nerror)
      if(nerror .gt. 0)then
      return
      endif
      now = nadj(j,1)
      nxt = nadj(j,2)
      ngap = 0
23002 continue
      call swap(j,now,nxt,didswp,nadj,madj,x,y,ntot,eps,nerror)
      if(nerror .gt. 0)then
      return
      endif
      n = nadj(j,0)
      if(.not.didswp)then
      now = nxt
      ngap = ngap+1
      endif
      call succ(nxt,j,now,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
23003 if(.not.(ngap.eq.n))goto 23002
23004 continue
      return
      end
