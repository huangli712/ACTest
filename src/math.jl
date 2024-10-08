#
# Project : Lily
# Source  : math.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/14
#

#
# BE CAREFUL:
#
# The algorithms as implemented here are designed for the ACTest package
# only. Some of them are oversimplified to get better performance. Thus
# they won't work for general cases sometimes. Anyway, it is not a good
# idea to adopt these functions outside the ACTest package. Please use
# popular Julia's packages in your codes.
#

#=
### *Math* : *Numerical Integrations*
=#

"""
    trapz(x::AbstractMesh, y::AbstractVector{T}) where {T<:N64}

Perform numerical integration by using the composite trapezoidal rule.

### Arguments
* x -> Real frequency mesh.
* y -> Function values at real axis.

### Returns
* ℐ -> The final value.

See also: [`simpson`](@ref).
"""
function trapz(x::AbstractMesh, y::AbstractVector{T}) where {T<:N64}
    value = dot(x.weight, y)
    return value
end

"""
    trapz(
        x::AbstractVector{S},
        y::AbstractVector{T},
        linear::Bool = false
    ) where {S<:Number, T<:Number}

Perform numerical integration by using the composite trapezoidal rule.
Note that it supports arbitrary precision via BigFloat.

### Arguments
* x      -> Real frequency mesh.
* y      -> Function values at real axis.
* linear -> Whether the given mesh is linear?

### Returns
* ℐ -> The final value.

See also: [`simpson`](@ref).
"""
function trapz(
    x::AbstractVector{S},
    y::AbstractVector{T},
    linear::Bool = false
    ) where {S<:Number, T<:Number}
    # For linear mesh
    if linear
        h = x[2] - x[1]
        value = y[1] + y[end] + 2.0 * sum(y[2:end-1])
        value = h * value / 2.0
    # For non-equidistant mesh
    else
        len = length(x)
        dx = view(x, 2:len) .- view(x, 1:(len-1))
        y_forward = view(y, 2:len)
        y_backward = view(y, 1:(len-1))
        value = sum(0.5 * (y_forward .+ y_backward) .* dx)
    end

    return value
end

"""
    simpson(
        x::AbstractVector{S},
        y::AbstractVector{T}
    ) where {S<:Number, T<:Number}

Perform numerical integration by using the simpson rule. Note that the
length of `x` and `y` must be odd numbers. And `x` must be a linear and
uniform mesh.

### Arguments
* x -> Real frequency mesh.
* y -> Function values at real axis.

### Returns
* ℐ -> The final value.

See also: [`trapz`](@ref).
"""
function simpson(
    x::AbstractVector{S},
    y::AbstractVector{T}
    ) where {S<:Number, T<:Number}
    h = (x[2] - x[1]) / 3.0

    even_sum = 0.0
    odd_sum = 0.0
    for i = 2:length(x)-1
        if iseven(i)
            even_sum = even_sum + y[i]
        else
            odd_sum = odd_sum + y[i]
        end
    end

    return h * (y[1] + y[end] + 4.0 * even_sum + 2.0 * odd_sum)
end

#=
### *Math* : *Einstein Summation Convention*
=#

#=
*Remarks* :

The following codes realize a single macro `@einsum`, which implements
*similar* notation to the Einstein summation convention to flexibly
specify operations on Julia `Array`s, similar to numpy's `einsum`
function (but more flexible!).

This implementation was borrowed from the following github repository:

* https://github.com/ahwillia/Einsum.jl

Of course, small modifications are made.
=#

"""
    @einsum(ex)

Perform Einstein summation like operations on Julia `Array`s.

### Examples

Basic matrix multiplication can be implemented as:

```julia
@einsum A[i, j] := B[i, k] * C[k, j]
```

If the destination array is preallocated, then use `=`:

```julia
A = ones(5, 6, 7) # Preallocated space
X = randn(5, 2)
Y = randn(6, 2)
Z = randn(7, 2)

# Store the result in A, overwriting as necessary:
@einsum A[i, j, k] = X[i, r] * Y[j, r] * Z[k, r]
```

If destination is not preallocated, then use `:=` to automatically create
a new array for the result:

```julia
X = randn(5, 2)
Y = randn(6, 2)
Z = randn(7, 2)

# Create new array B with appropriate dimensions:
@einsum B[i, j, k] := X[i, r] * Y[j, r] * Z[k, r]
```
"""
macro einsum(ex)
    _einsum(ex)
end

# Core function
function _einsum(expr::Expr, inbounds = true)
    # Get left hand side (lhs) and right hand side (rhs) of equation
    lhs = expr.args[1]
    rhs = expr.args[2]

    # Get info on the left hand side
    lhs_arrays, lhs_indices, lhs_axis_exprs = extractindices(lhs)

    # Get info on the right hand side
    rhs_arrays, rhs_indices, rhs_axis_exprs = extractindices(rhs)

    check_index_occurrence(lhs_indices, rhs_indices)

    # Remove duplicate indices on left hand and right hand side
    # and ensure that the array sizes match along these dimensions.
    dimension_checks = Expr[]

    # Remove duplicate indices on the right hand side
    for i in reverse(eachindex(rhs_indices))
        duplicated = false
        di = rhs_axis_exprs[i]

        for j = 1:(i - 1)
            if rhs_indices[j] == rhs_indices[i]
                duplicated = true
                dj = rhs_axis_exprs[j]
                push!(dimension_checks, :(@assert $dj == $di))
            end
        end

        for j = eachindex(lhs_indices)
            if lhs_indices[j] == rhs_indices[i]
                dj = lhs_axis_exprs[j]
                if Meta.isexpr(expr, :(:=))
                    # expr.head is :=
                    # Infer the size of the lhs array
                    lhs_axis_exprs[j] = di
                else
                    # expr.head is =, +=, *=, etc.
                    lhs_axis_exprs[j] = :(min($dj, $di))
                end
                duplicated = true
            end
        end

        if duplicated
            deleteat!(rhs_indices, i)
            deleteat!(rhs_axis_exprs, i)
        end
    end

    # Remove duplicate indices on the left hand side
    for i in reverse(eachindex(lhs_indices))
        duplicated = false
        di = lhs_axis_exprs[i]

        # Don't need to check rhs, already done above

        for j = 1:(i - 1)
            if lhs_indices[j] == lhs_indices[i]
                duplicated = true
                dj = lhs_axis_exprs[j]
                push!(dimension_checks, :(@assert $dj == $di))
            end
        end

        if duplicated
            deleteat!(lhs_indices, i)
            deleteat!(lhs_axis_exprs, i)
        end
    end

    # Create output array if specified by user
    @gensym T

    if Meta.isexpr(expr, :(:=))
        rhs_type = :(promote_type($([:(eltype($arr)) for arr in rhs_arrays]...)))
        type_definition = :(local $T = $rhs_type)
        output_definition = if length(lhs_axis_exprs) > 0
            :($(lhs_arrays[1]) = Array{$T}(undef, $(lhs_axis_exprs...)))
        else
            :($(lhs_arrays[1]) = zero($T))
        end
        assignment_op = :(=)
    else
        type_definition = :(local $T = eltype($(lhs_arrays[1])))
        output_definition = :(nothing)
        assignment_op = expr.head
    end

    # Copy the index expression to modify it.
    # loop_expr is the Expr we'll build loops around.
    loop_expr = unquote_offsets!(copy(expr))

    # Nest loops to iterate over the destination variables
    if length(rhs_indices) > 0
        # Innermost expression has form s += rhs
        @gensym s
        loop_expr.args[1] = s
        loop_expr.head = :(+=)

        # Nest loops to iterate over the summed out variables
        loop_expr = nest_loops(loop_expr, rhs_indices, rhs_axis_exprs)

        # Prepend with s = 0, and append with assignment
        # to the left hand side of the equation.
        lhs_assignment = Expr(assignment_op, lhs, s)

        loop_expr = quote
            local $s = zero($T)
            $loop_expr
            $lhs_assignment
        end

        # Now loop over indices appearing on lhs, if any.
        loop_expr = nest_loops(loop_expr, lhs_indices, lhs_axis_exprs)
    else
        # We do not sum over any indices, only loop over lhs.
        loop_expr.head = assignment_op
        loop_expr = nest_loops(loop_expr, lhs_indices, lhs_axis_exprs)
    end

    # Check bounds
    if inbounds
        loop_expr = :(@inbounds $loop_expr)
    end

    full_expression = quote
        $type_definition
        $output_definition
        $(dimension_checks...)

        let $([lhs_indices; rhs_indices]...)
            $loop_expr
        end

        $(lhs_arrays[1])
    end

    return esc(full_expression)
end

# Check validity
function check_index_occurrence(lhs_indices, rhs_indices)
    if !issubset(lhs_indices, rhs_indices)
        missing_indices = setdiff(lhs_indices, rhs_indices)

        if length(missing_indices) == 1
            missing_string = "\"$(missing_indices[1])\""
            throw(ArgumentError(string(
                "Index ", missing_string, " is occuring only on left side")))
        else
            missing_string = join(("\"$ix\"" for ix in missing_indices),
                                  ", ", " and ")
            throw(ArgumentError(string(
                "Indices ", missing_string, " are occuring only on left side")))
        end
    end
end

# Expand loops
function nest_loops(expr::Expr, index_names::Vector{Symbol}, axis_expressions::Vector{Expr})
    isempty(index_names) && return expr

    expr = nest_loop(expr, index_names[1], axis_expressions[1])
    for j = 2:length(index_names)
        expr = nest_loop(expr, index_names[j], axis_expressions[j])
    end

    return expr
end

# Expand loops
function nest_loop(expr::Expr, index_name::Symbol, axis_expression::Expr)
    loop = :(for $index_name = 1:$axis_expression
                 $expr
             end)
    return loop
end

extractindices(expr) = extractindices!(expr, Symbol[], Symbol[], Expr[])

function extractindices!(expr::Symbol,
                         array_names::Vector{Symbol},
                         index_names::Vector{Symbol},
                         axis_expressions::Vector{Expr})
    push!(array_names, expr)
    return array_names, index_names, axis_expressions
end

function extractindices!(expr::Number,
                         array_names::Vector{Symbol},
                         index_names::Vector{Symbol},
                         axis_expressions::Vector{Expr})
    return array_names, index_names, axis_expressions
end

function extractindices!(expr::Expr,
                         array_names::Vector{Symbol},
                         index_names::Vector{Symbol},
                         axis_expressions::Vector{Expr})
    if Meta.isexpr(expr, :ref)
        array_name = expr.args[1]
        push!(array_names, array_name)
        for (dimension, index_expr) in enumerate(expr.args[2:end])
            pushindex!(index_expr,
                       array_name,
                       dimension,
                       array_names,
                       index_names,
                       axis_expressions)
        end
    elseif Meta.isexpr(expr, :call)
        for arg in expr.args[2:end]
            extractindices!(arg, array_names, index_names, axis_expressions)
        end
    else
        throw(ArgumentError("Invalid expression head: `:$(expr.head)`"))
    end

    return return array_names, index_names, axis_expressions
end

function pushindex!(expr::Symbol,
                    array_name::Symbol,
                    dimension::Int,
                    array_names,
                    index_names,
                    axis_expressions)
    push!(index_names, expr)
    push!(axis_expressions, :(size($array_name, $dimension)))
end

function pushindex!(expr::Number,
                    array_name::Symbol,
                    dimension::Int,
                    array_names,
                    index_names,
                    axis_expressions)
    return nothing
end

function pushindex!(expr::Expr,
                    array_name::Symbol,
                    dimension::Int,
                    array_names,
                    index_names,
                    axis_expressions)
    if Meta.isexpr(expr, :call) && length(expr.args) == 3
        op = expr.args[1]

        index_name = expr.args[2]
        @assert typeof(index_name) == Symbol

        offset_expr = expr.args[3]

        if offset_expr isa Integer
            offset = expr.args[3]::Integer
        elseif offset_expr isa Expr && Meta.isexpr(offset_expr, :quote)
            offset = offset_expr.args[1]
        elseif offset_expr isa QuoteNode
            offset = offset_expr.value
        else
            throw(ArgumentError("Improper expression inside reference on rhs"))
        end

        push!(index_names, index_name)

        if op == :+
            push!(axis_expressions, :(size($array_name, $dimension) - $offset))
        elseif op == :-
            push!(axis_expressions, :(size($array_name, $dimension) + $offset))
        else
            throw(ArgumentError(string("Operations inside ref on rhs are ",
                                       "limited to `+` and `-`")))
        end
    elseif Meta.isexpr(expr, :quote)
        return nothing
    else
        throw(ArgumentError("Invalid index expression: `$(expr)`"))
    end
end

function unquote_offsets!(expr::Expr, inside_ref = false)
    inside_ref |= Meta.isexpr(expr, :ref)

    for i in eachindex(expr.args)
        if expr.args[i] isa Expr
            if Meta.isexpr(expr.args[i], :quote) && inside_ref
                expr.args[i] = expr.args[i].args[1]
            else
                unquote_offsets!(expr.args[i], inside_ref)
            end
        end
    end

    return expr
end
