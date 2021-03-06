function [X, X_dot,J_opt,exitflag,Result,Prob] = ...
    compute_geodesic_tom(Prob,n,N,...
    start_p,end_p,...
    T_e,T_dot_e,Aeq,warm)


beq = [start_p; end_p];

Prob = replace_A(Prob,Aeq,beq,beq);

if (~warm.sol)
    vars_0 = zeros(n*(N+1),1);
    for i = 1:n
        vars_0((i-1)*(N+1)+1:(i-1)*(N+1)+2) = [(start_p(i)+end_p(i))/2;
            -(start_p(i)-end_p(i))/2];
    end
    Prob = modify_x_0(Prob,vars_0);
else
    Prob = WarmDefSOL('npsol',Prob,warm.result);
end

if ~Prob.CHECK
    Prob = ProbCheck(Prob,'npsol');
end

Result = npsolTL(Prob);

C_opt = (reshape(Result.x_k,N+1,n))';
X = C_opt*T_e;
X_dot = 2*C_opt*T_dot_e;

J_opt = Result.f_k;
exitflag = Result.Inform;%GOOD: {0,1,6}

end



