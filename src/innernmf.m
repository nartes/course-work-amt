function [W,H,d] = innernmf(V, r = 2)
  [n, m] = size(V);

  PERGRADIENT = 1000;
  count = 0;
  MAX_ITER = 10000;

  do
    W = rand(n, r); H = rand(r, m);

    #updateH = @(V,H,W) H .* sum(W)' .* sum(V) ./ sum(W*H) ./ sum(W)';
    #updateW = @(V,H,W) W .* sum(H, 2)' .* sum(V, 2) ...
    #            ./ sum(W * H, 2) ./ sum(H, 2)';
    updateH = @(V, H, W) H .* (W' * V) ./ (W' * W * H);
    updateW = @(V, H, W) W .* (V * H') ./ (W * H * H');

    D = @(A,B) sum(sum(A .* log (A ./ B) .- A .+ B));
    N = @(A, B) sum(sumsq(A .- B));

    #while (D(V, W * H) > 0.1)
    printf("N is %d\n", N(V, W * H));
    while (N(V, W * H) > 0.1)
      H = updateH(V, H, W);
      W = updateW(V, H, W);

      ++count;
      if (rem(count, PERGRADIENT) == 0)
        break;
      end
      printf("N is %d\n", N(V, W * H));
    endwhile

    d = N(V, W * H);
  until (d < 0.1 || count == MAX_ITER)
  printf("Iter is %d\n", count);
endfunction
