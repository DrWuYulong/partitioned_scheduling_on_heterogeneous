function gain = CompGain(topology,u,part,d)
%dΪ��Ҫ��u�����ȥ��part
gain = 0;

pred_u = find(topology(:,u) == 1);
succ_u = find(topology(u,:) == 1);

for v = 1:length(pred_u)
    if part(u) == part(v)
        gain = gain - 1;
    elseif part(v) == d
            gain = gain + 1;
    end
end

for v = 1:length(succ_u)
    if part(u) == part(v)
        gain = gain - 1;
    elseif part(v) == d
            gain = gain + 1;
    end
    

end