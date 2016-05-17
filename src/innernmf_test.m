function innernmf_test
  test_nmf_pg_and_innernmf();
end

function test_nmf_pg_and_innernmf
  a = [0 0 0 0,
       1 0 0 0
       1 1 0 0
       0 0 0 0];

  [W0, H0] = nmf_pg(a, 'Winit', rand(4, 2),
                       'Hinit', rand(2, 4),
                       'tol', 1e-4);

  [W1, H1, d, iter] = innernmf(a, 2, 1e-2);
  %[W1, H1] = innernmf(a, 2); %, 1e-1);

  printf("Distance = %d\n", d);
  printf("Iterations = %d\n", iter);

  dist = sumsq((W0 * H0 - W1 * H1)(:));
  if  dist > 1e-2
    error(["nmf_pg and innernmf should have similar precision\n",...
           sprintf("distance is %d", sumsq(dist))]);
  end
end
