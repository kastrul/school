classdef dbscan
methods (Static)

function revStr = printOneRow(msg, revStr)
  fprintf([revStr, msg]);
  revStr = repmat(sprintf('\b'), 1, length(msg));
end

function out = rangeQuery(points, q, e)
  out = Point.empty;
  count = 0;
  for i = 1:length(points)
    p = points(i);
    if DistanceFunctions.manh(q.Coordinate, p.Coordinate) <= e
      count = count + 1;
      out(count) = p;
    end
  end
end


function out = clusters(out, e, minPts)
  new_label = 0;
  revStr1 = '';
  revStr3 = '';
  for i = 1:length(out)
    clc
    msg = sprintf('\nLoading %d/%d', i, length(out));
    revStr1 = dbscan.printOneRow(msg, revStr1);

    if out(i).Label ~= 0 % Take new point when not undefined
      continue;
    end

    % array of points in range
    range = dbscan.rangeQuery(out, out(i), e);

    if length(range) < minPts
      out(i).Label = -1; % Noise, when too few points in range
      continue;
    end

    new_label = new_label + 1;

    msg_lbl = sprintf('\nLabel %d', new_label);
    recStr3 = dbscan.printOneRow(msg_lbl, revStr3);

    out(i).Label = new_label; % Assign label to point

    mask = arrayfun(@(x) ~isequal(x.Coordinate, out(i).Coordinate), range);
    seed = range(mask);
    s_index = 1;

    %% Labels core points neighbourhood
    revStr2 = '';
    while s_index < length(seed)
      msg2 = sprintf('\nLoading seed %d/%d', s_index, length(seed));
      revStr2 = dbscan.printOneRow(msg2, revStr2);
      index = seed(s_index).Index;

      s_index = s_index + 1;

      if out(index).Label == -1
        out(index).Label = new_label;
      end

      if out(index).Label ~= 0
        continue;
      end

      out(index).Label = new_label;
      n_cluster = dbscan.rangeQuery(out, out(index), e);
      if length(n_cluster) >= minPts
        seed = [seed, n_cluster];
      end
    end
  end
end

function drawClusters(points)
  label = -1;
  revStr = '';
  index = 1;
  %% plotting loop
  while 1
    if label == 0
      label = 1;
    end
    mask = arrayfun(@(x) isequal(x.Label, label), points);
    cluster = points(mask);
    if isempty(cluster) && label ~= -1
      break;
    end
    array = Point.toArray(cluster);
    scatter(array(:,1), array(:,2), [], 'filled');
    Legend{index}=strcat('Points: ', num2str(length(cluster)));
    hold on;
    revStr = dbscan.printOneRow(label, revStr);
    label = label + 1;
    index = index + 1;
  end
  legend(Legend)
end
end

end
