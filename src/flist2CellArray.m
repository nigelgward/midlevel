%% flist is a list of one-per-feature structures
%% this function just returns a list of names
function cellA = flist2CellArray(flist)
  cellA = {};
  for i = 1:length(flist)
    cellA = vertcat(cellA, flist(i).abbrev);
  end
end

