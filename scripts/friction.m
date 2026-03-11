function Ft = friction(Fothert, Fn, v, mu_s, mu_k)
  if norm(v) == 0  % relative velocity is zero: static friction

    if norm(Fothert) < mu_s * norm(Fn)
      Ft = -Fothert;
    else
      Ft = 0;
    end

  else  % relative velocity is zero: kinetic friction
    Ft = -mu_k * norm(Fn) * v / norm(v);
  end

end
