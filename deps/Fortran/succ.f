C Output from Public domain Ratfor, version 1.0
      subroutine succ(ksc,i,j,nadj,madj,ntot,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj)
      nerror = -1
      n = nadj(i,0)
      if(n.eq.0)then
      nerror = 9
      return
      endif
      do23002 k = 1,n 
      if(j.eq.nadj(i,k))then
      kp = k+1
      if(kp.gt.n)then
      kp = 1
      endif
      ksc = nadj(i,kp)
      return
      endif
23002 continue
23003 continue
      nerror = 10
      return
      end
