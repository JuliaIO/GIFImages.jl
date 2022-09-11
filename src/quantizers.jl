# In this file, we have the color quantisation algorithms

function split_buckets(img, data, depth)
    if length(data) == 0 return end

    # Buckets are same size,
    # means that each colors is assigned to
    # equal number of pixels here.
    if depth == 0
        # this behavior is interesting of N0f8
        # and of floats as it's messing up results
        avg = RGB{N0f8}.(mean(map(x -> x[2], data)))
        map(x -> img[x[1]] = avg, data)
        return
    end

    # find range of colors and pick color which
    # most difference in max val and min val
    rmin, rmax = 1.0N0f8, 0.0N0f8
    gmin, gmax = 1.0N0f8, 0.0N0f8
    bmin, bmax = 1.0N0f8, 0.0N0f8
    for (idx, color) in data
        if (color.r > rmax) rmax = color.r end
        if (color.g > gmax) gmax = color.g end
        if (color.b > bmax) bmax = color.b end
        if (color.r < rmin) rmin = color.r end
        if (color.g < gmin) gmin = color.g end
        if (color.b < bmin) bmin = color.b end
    end

    ind = findmax([rmax - rmin, gmax - gmin, bmax - bmin])[2]

    # sort on basis of max range color
    if ind == 1 sort!(data; by = c -> c[2].r)
    elseif ind == 2 sort!(data; by = c -> c[2].g)
    elseif ind == 3 sort!(data; by = c -> c[2].b) end

    # start diving on basis of median index
    medind = trunc(Int, (length(data) + 1) / 2)

    # two separate buckets
    split_buckets(img, data[1:medind], depth - 1)
    split_buckets(img, data[medind+1:end], depth - 1)
end


function mediancut!(img, max = 6)
    data = map(x -> x, enumerate(vec(img)))
    split_buckets(img, data, max)
end

function mediancut(img, max = 6)
    img1 = deepcopy(img)
    mediancut!(img1, max)
    return img1
end

function putin(root, in)
    color_in = in[2]
    r, g, b = map(p->bitstring(UInt8(p*255)), [color_in.r, color_in.g, color_in.b])

    # finding the entry to the tree
    ind = 0
    for i = 1:8
        if (root.children[i].data[1] == r[1] * g[1] * b[1])
            root.children[i].data[2] += 1
            ind = i
            break
        end
    end
    curr = root.children[ind]
    
    for i = 2:8
        cases = map(p->[bitstring(UInt8(p))[6:end], 0, Vector{Int}([]), RGB{N0f8}.(0.0,0.0,0.0), i], 1:8)
        if (isleaf(curr) == true && i < 8) split!(curr, cases) end
        if (i == 8)
            if (isleaf(curr) == true) split!(curr, cases) end
            for j = 1:8
                if (curr.children[j].data[1] ==  r[i] * g[i] * b[i])
                    curr = curr.children[j]
                    curr.data[2] += 1
                    push!(curr.data[3], in[1])
                    curr.data[4] = in[2]
                    return
                end
            end
        end

        # handle 1:7 cases for rgb to handle first seven bits
        for j = 1:8
            if (curr.children[j].data[1] ==  r[i] * g[i] * b[i])
                curr.children[j].data[2] += 1
                curr = curr.children[j]
                break
            end
        end
    end
end


function octreequantisation!(img; numcolors = 256, return_palette = false )
    # step 1: creating the octree
    root = Cell(SVector(0.0, 0.0, 0.0), SVector(1.0, 1.0, 1.0), ["root", 0, [], RGB{N0f8}.(0.0, 0.0, 0.0), 0])
    cases = map(p->[bitstring(UInt8(p))[6:end], 0, Vector{Int}([]), RGB{N0f8}.(0.0,0.0,0.0), 1], 1:8)
    split!(root, cases)
    for i in enumerate(img)
        root.data[2]+=1
        putin(root, i)
    end
    
    # step 2: reducing tree to a certain number of colors
    # there is scope for improvements in allleaves as it's found again n again
    leafs = [p for p  in allleaves(root)]
    filter!(p -> !iszero(p.data[2]), leafs)
    tobe_reduced = leafs[1]

    while (length(leafs) > numcolors)
        parents = unique([parent(p) for p in leafs])
        parents = sort(parents; by = c -> c.data[2])
        tobe_reduced = parents[1]

        for i = 1:8
            append!(tobe_reduced.data[3], tobe_reduced.children[i].data[3])
            tobe_reduced.data[4] += tobe_reduced.children[i].data[4] * tobe_reduced.children[i].data[2]
        end
        tobe_reduced.data[4] /= tobe_reduced.data[2]
        tobe_reduced.children = nothing

        # we don't want to do this again n again
        leafs = [p for p  in allleaves(root)]
        filter!(p -> !iszero(p.data[2]), leafs)
    end

    # step 3: palette formation  and quantisation now
    da = [p.data for p in leafs]
    for i in da
        for j in i[3]
            img[j] = i[4]
        end
    end

    if return_palette == true
        colors = [p[4] for p in da]
        return colors
    end
end

function octreequantisation(img; kwargs...)
    img1 = deepcopy(img)
    # possible error likely here to return palette kwarg
    octreequantisation!(img1; kwargs...)
    return img1
end