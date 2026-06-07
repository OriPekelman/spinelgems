# smoke: red-arrow-cuda
# red-arrow-cuda wraps Apache Arrow CUDA buffers via GObject Introspection.
# Full functionality requires libarrow-cuda-glib (native C) and a CUDA device.
# We exercise the pure-Ruby Version module which contains real computation:
# splitting the version string into components and building the module constants.

require 'arrow-cuda/version'

# VERSION is a plain string constant
puts ArrowCUDA::VERSION

# Version::MAJOR/MINOR/MICRO are computed by splitting VERSION on '.' and
# calling to_i — real logic, deterministic, Spinel-compilable.
puts ArrowCUDA::Version::MAJOR
puts ArrowCUDA::Version::MINOR
puts ArrowCUDA::Version::MICRO

# STRING is an alias for VERSION
puts ArrowCUDA::Version::STRING

# TAG is nil when there is no pre-release suffix
puts ArrowCUDA::Version::TAG.nil?

# Demonstrate that the version parts reconstruct the original string
reconstructed = [
  ArrowCUDA::Version::MAJOR,
  ArrowCUDA::Version::MINOR,
  ArrowCUDA::Version::MICRO
].join('.')
puts reconstructed == ArrowCUDA::VERSION
puts reconstructed
