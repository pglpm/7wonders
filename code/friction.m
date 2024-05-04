function F_fr = friction(Fother_x, Fother_z, v_x, mu_s, mu_k)
  if v_x == 0 % static friction
    threshold = mu_s * abs(Fother_z); % max magnitude
    if abs(Fother_x) <= threshold
      F_fr = -Fother_x;
    else
      F_fr = -sign(Fother_x) * threshold;
    end
  else % kinetic friction
    F_fr = -sign(v_x) * mu_k * abs(Fother_z);
  end
end
