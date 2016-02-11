C Output from Public domain Ratfor, version 1.0
      subroutine delet(i,j,nadj,madj,ntot,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj)
      logical adj
      call adjchk(i,j,adj,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(adj)then
      call delet1(i,j,nadj,madj,ntot)
      call delet1(j,i,nadj,madj,ntot)
      endif
      return
      end
