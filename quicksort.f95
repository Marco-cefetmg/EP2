!Porte do rng-java8 para fortran95 
!@author Marco Aurélio
program main
   use iso_fortran_env
   implicit none
   INTEGER(int64) :: seed
   INTEGER :: i, arr_s
   INTEGER, DIMENSION(:), ALLOCATABLE :: ARR
   REAL(int64) :: T1,T2
   
   arr_s = 50000 ! array size

   seed = X'70A0A0A0A0A0A0A0'

   ALLOCATE(ARR(arr_s))
   do i = 1, arr_s
      ARR(i) = next(31)
   end do

   !WRITE(*,'(A/,*(I11))')'unsorted:', ARR(:)

   CALL cpu_time(T1)
   CALL quicksort(ARR, 1, SIZE(ARR))
   CALL cpu_time(T2)

   !WRITE(*,'(A/,*(I11))')'sorted:', ARR(:)
   WRITE(*,'(A, EN16.8)') 'time elapsed:', (T2-T1)

   DEALLOCATE(ARR)

contains
    !RNG-java8
    function next(bits) result(retval)
      implicit none
      INTEGER, INTENT(IN) :: bits
      INTEGER :: retval
      
      seed = AND((seed * X'5DEECE66D' + X'B'), (ISHFT(1_int64, 48) - 1))
      !seed = IAND((seed * X'5DEECE66D' + X'B'), X'ffffffffffffffff') !mask problem
      retval = INT(ISHFT(seed, -(48 - bits)))
      
   end function next
   
   function partition(A, left, right) result(returnval)
      implicit none
      INTEGER, DIMENSION(:), INTENT(INOUT) :: A
      INTEGER, INTENT(IN) :: left, right
      INTEGER :: pivot, i, j, temp, returnval
      
      pivot = A(right)
      i = left-1
      
      do j = left, (right-1)
         if (A(j) <= pivot) then
            i=i+1
            temp = A(i); A(i) = A(j); A(j) = temp
         end if
      end do
      temp = A(i+1); A(i+1) = A(right); A(right) = temp
      returnval = i+1
   end function partition
   
   recursive subroutine quicksort(A, left, right)
   implicit none
   INTEGER, DIMENSION(:), INTENT(INOUT) :: A
   INTEGER,INTENT(IN) :: left, right
   INTEGER :: marker
   
   if (left<right) then
      marker = partition(A, left, right)
      CALL quicksort(A, left, marker-1)
      CALL quicksort(A, marker+1, right)
   end if
   
end subroutine quicksort
end program main
