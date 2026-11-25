extends GutTest

# Test if your CPU is dysfunctional (assume all tests to be invalid if this fails)
func test_cpu():
	assert_ne(0.3, 0.03, "Testing if your CPU is broken (0.3 != 0.03)")
