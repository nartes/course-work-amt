function [W,H,d,iter] = innernmf(V, r = 2, tol = 1e-2,
                                 max_iter = 100, attempts = 5)
  [n, m] = size(V);

  PERGRADIENT = max_iter;
  count = 0;
  MAX_ITER = attempts * PERGRADIENT;

  bestW = rand(n, r);
  bestH = rand(r, m);
  bestd = Inf;

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
    while (N(V, W * H) > tol)
      tH = updateH(V, H, W);
      H(!isnan(tH)) = tH(!isnan(tH));
      tW = updateW(V, H, W);
      W(!isnan(tW)) = tW(!isnan(tW));

      ++count;
      if (rem(count, PERGRADIENT) == 0)
        break;
      end
    endwhile
    d = N(V, W * H);

    if d < bestd
      bestH = H;
      bestW = W;
      bestd = d;
    end
  until (d < 0.1 || count == MAX_ITER)

  d = bestd;
  W = bestW;
  H = bestH;
  iter = count;
endfunction
