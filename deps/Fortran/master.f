C Output from Public domain Ratfor, version 1.0
      subroutine master(x,y,sort,rw,npd,ntot,nadj,madj,ind,tx,ty,ilst,ep
     *s, delsgs,ndel,delsum,dirsgs,ndir,dirsum,nerror)
      implicit double precision(a-h,o-z)
      logical sort, adj
      dimension x(-3:ntot), y(-3:ntot)
      dimension nadj(-3:ntot,0:madj)
      dimension ind(npd), tx(npd), ty(npd), ilst(npd), rw(4)
      dimension delsgs(6,ndel), dirsgs(8,ndir)
      dimension delsum(npd,4), dirsum(npd,3)
      one = 1.d0
      if(sort)then
      call binsrt(x,y,ntot,rw,npd,ind,tx,ty,ilst,nerror)
      if(nerror .gt. 0)then
      return
      endif
      else
      do23004 i = 1,npd 
      ind(i) = i
23004 continue
23005 continue
      endif
      do23006 i = -3,ntot 
      nadj(i,0) = 0
      do23008 j = 1,madj 
      nadj(i,j) = -99
23008 continue
23009 continue
23006 continue
23007 continue
      x(-3) = -one
      y(-3) = one
      x(-2) = one
      y(-2) = one
      x(-1) = one
      y(-1) = -one
      x(0) = -one
      y(0) = -one
      do23010 i = 1,4 
      j = i-4
      k = j+1
      if(k.gt.0)then
      k = -3
      endif
      call insrt(j,k,nadj,madj,x,y,ntot,nerror,eps)
      if(nerror.gt.0)then
      return
      endif
23010 continue
23011 continue
      do23016 i = 1,4 
      j = i-4
      call insrt(1,j,nadj,madj,x,y,ntot,nerror,eps)
      if(nerror.gt.0)then
      return
      endif
23016 continue
23017 continue
      do23020 j = 2,npd 
      call addpt(j,nadj,madj,x,y,ntot,eps,nerror)
      if(nerror.gt.0)then
      return
      endif
23020 continue
23021 continue
      call delseg(delsgs,ndel,nadj,madj,npd,x,y,ntot,ind,nerror)
      if(nerror.gt.0)then
      return
      endif
      call delout(delsum,nadj,madj,x,y,ntot,npd,ind,nerror)
      if(nerror.gt.0)then
      return
      endif
      call dirseg(dirsgs,ndir,nadj,madj,npd,x,y,ntot,rw,eps,ind,nerror)
      if(nerror.gt.0)then
      return
      endif
      call dirout(dirsum,nadj,madj,x,y,ntot,npd,rw,ind,eps,nerror)
      return
      end
