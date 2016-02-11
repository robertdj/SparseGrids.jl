C Output from Public domain Ratfor, version 1.0
      subroutine insrt(i,j,nadj,madj,x,y,ntot,nerror,eps)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      logical adj
      call adjchk(i,j,adj,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(adj)then
      return
      endif
      call locn(i,j,kj,nadj,madj,x,y,ntot,eps)
      call locn(j,i,ki,nadj,madj,x,y,ntot,eps)
      call insrt1(i,j,kj,nadj,madj,ntot,nerror)
      if(nerror .gt.0)then
      return
      endif
      call insrt1(j,i,ki,nadj,madj,ntot,nerror)
      if(nerror .gt.0)then
      return
      endif
      return
      end
