# define secondary source type
# ensure that it is a nx7 matrix
type SecondarySources
    positions::Array{Number,2}
    directions::Array{Number,2}
    weights::Vector{Number}
    # FIXME: make constructor work with new x0 definition
    SecondarySources(x0::Array) = size(x0,2)!=7 ? error("SecondarySources has to have 7 columns") : new(x0)
end

import Base.size
import Base.length
# add normal functions to work with SecondarySources
size(x0::SecondarySources,dim::Integer) = size(x0.x0,1)
size(x0::SecondarySources) = size(x0.x0,1)
length(x0::SecondarySources) = size(x0)

# add all the functions dealing with secondary sources


# === distance between secondary sources
function distance(x0::SecondarySources,approx::Bool)
    if size(x0)==1
        # if we have only one secondary source
        dx0 = Inf;
    else
        if approx
            # approximate by using only the first <=100 sources
            x0.positions = x0.positions[1:min(100,size(x0)),:];
        end
        dx0_single = zeros(size(x0),1);
        for ii=1:size(x0)
            # first secondary source position
            x01 = x0.positions[ii];
            # all other positions
            x02 = [x0.positions[1:ii-1]; x0.positions[ii+1:end]];
            # get distance between x01 and all secondary sources within x02
            dist = vectornorm(broadcast(-,x02,x01),2);
            # this is maybe the same
            #dist = vectornorm(x02.-x01,2);
            # get the smallest distance (which is the one to the next source)
            dx0_single[ii] = min(dist);
        end
        # get the mean distance between all secondary sources
        dx0 = mean(dx0_single);
    end
    return dx0
end
distance(x0::SecondarySources) = distance(x0,false)


# === secondary source selection for WFS
function selection(x0::SecondarySources,xs::PlaneWave)
    # add code
    x0, idx
end
function selection(x0::SecondarySources,xs::PointSource)
    # add code
    x0, idx
end
# ...



