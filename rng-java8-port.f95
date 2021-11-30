!Porte do rng-java8 para fortran95 
!@author Marco Aurélio
program main
    use iso_fortran_env
    implicit none
    INTEGER(int64) :: seed
    INTEGER :: i
    
    CALL setseed(0_16)
    do i = 1, 20
        print *, next(31)
    end do

    CALL setseed(X'FFFFFFFFFFFFFFFF')
    do i = 1, 20
        print *, next(31)
    end do

    CALL setseed(X'A0A0A0A0A0A0A0A0')
    do i = 1, 20
        print *, next(31)
    end do

    contains
    subroutine setseed(newSeed)
        implicit none
        INTEGER(KIND=16), INTENT(IN) :: newSeed

        seed = AND((TRANSFER(XOR(newSeed, X'5DEECE66D'), 1_int64)), (ISHFT(1_int64, 48) - 1))

    end subroutine setseed

    function next(bits) result(retval)
        implicit none
        INTEGER, INTENT(IN) :: bits
        INTEGER :: retval

        seed = AND(TRANSFER(seed * X'5DEECE66D' + X'B', 1_int64), (ISHFT(1_int64, 48) - 1))
        retval = INT(ISHFT(seed, -(48 - bits)))
        
    end function next
end program main