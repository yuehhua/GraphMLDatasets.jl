"""
A: CSR matrix
Ax: nonzero data
Aj: column indices
Ap: row pointer
B: CSC matrix
Bx: nonzero data
Bi: row indices
Bp: column pointer

Ref: https://github.com/scipy/scipy/blob/3b36a574dc657d1ca116f6e230be694f3de31afc/scipy/sparse/sparsetools/csr.h#L380
"""
function csr2csc(nrow, ncol, Ax::Vector{T}, Aj::Vector{S}, Ap::Vector{S}}) where {T,S<:Integer}
    nnz = Ap[nrow]
    Bx = 
    Bi = 
    Bp = zeros(T, ncol)

    for i in 1:nnz
        Bp[Aj[i]] += 1
    end

    cumsum = 0
    for j in 1:ncol
        temp = Bp[j]
        Bp[j] = cumsum
        cumsum += temp
    end
    Bp[ncol] = nnz

    for i in 1:nrow
        for jj in Ap[i]:Ap[i+1]
            j = Aj[jj]
            dest = Bp[j]

            Bi[dest] = i
            Bx[dest] = Ax[jj]

            Bp[j] += 1
        end
    end

    last = 0
    for j in 1:ncol
        Bp[j], last = last, Bp[j]
    end
end