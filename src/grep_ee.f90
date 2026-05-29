subroutine run_ee()
  use common
  implicit none

  integer :: i, k, ios
  character(len=256) :: M
  real(8) :: s1, s2, s3, s4, s5, s6, s7, s8, s9
  logical :: time_read


  do i = 1, nfiles
    a(i) = 0.0d0
    t(i) = 0.0d0
    time_read = .false.

    write(M, '(A,I7.7)') 'feap.vtk.', i-1

    open(10, file=trim(M), status='old', iostat=ios)
    if (ios /= 0) then
      print *, "ERROR opening file: ", trim(M)
      stop
    end if

    do
      read(10,'(A)', iostat=ios) line
      if (ios /= 0) exit

      ! ===== 读 Time =====
      if (index(line, 'Time') /= 0) then
        read(10,'(A)', iostat=ios) line   ! Time 1 1 float
        if (ios /= 0) cycle
        read(10,*, iostat=ios) t(i)
        if (ios /= 0) cycle
        time_read = .true.
        cycle
      end if

      ! ===== 读 stress =====
      if (index(line, 'stress') == 1) then
        read(10,*, iostat=ios)   ! 跳过 stress 9 4225 float
        if (ios /= 0) cycle

        do k = 1, int(nn)
          read(10,*, iostat=ios) s1, s2, s3, s4, s5, s6, s7, s8, s9
          if (ios /= 0) exit
          a(i) = a(i) + s6   ! ✅ 用 Szz（如需 Sxx/Syy 改这里）
        end do

        exit   ! ✅ 读完 stress，结束本文件
      end if
    end do

    close(10)

    if (.not. time_read) then
      print *, "WARNING: no time found in feap.vtk.", i-1
    end if

    ! ===== 时间折叠 =====
    do while (t(i) > ts)
      t(i) = t(i) - ts
    end do

    if (t(i) <= ts*0.25d0) then
      E(i) = t(i)*(Ampl*4.0d0)/ts
    else if (t(i) > ts*0.25d0 .and. t(i) <= ts*0.75d0) then
      E(i) = t(i)*(-Ampl*4.0d0)/ts + Ampl*2.0d0
    else
      E(i) = t(i)*(Ampl*4.0d0)/ts - Ampl*4.0d0
    end if

    a(i) = a(i) / nn
  end do

  ! ===== 输出 CSV =====
  open(7, file=outname)
  do i = 1, nfiles
    write(7,'(E16.8,",",E16.8)') E(i), a(i)
  end do
  close(7)

end subroutine run_ee