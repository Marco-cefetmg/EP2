!Porte do rng-java8 para fortran95 
!@author Marco Aurélio
program main
    use iso_fortran_env
    implicit none
    INTEGER(int64) :: seed
    INTEGER :: i
    
    seed = 0
    do i = 1, 20
        print *, next(31)
    end do

     seed = X'7FFFFFFFFFFFFFFF'
     do i = 1, 20
         print *, next(31)
     end do

     seed = X'70A0A0A0A0A0A0A0'
     do i = 1, 20
         print *, next(31)
     end do


    contains
    
    function next(bits) result(retval)
        implicit none
        INTEGER, INTENT(IN) :: bits
        INTEGER :: retval
    
        seed = IAND((seed * X'5DEECE66D' + X'B'), (ISHFT(1_int64, 48) - 1))
        !seed = IAND((seed * X'5DEECE66D' + X'B'), X'ffffffffffffffff') !mask problem
        retval = INT(ISHFT(seed, -(48 - bits)))
        
    end function next
end program main