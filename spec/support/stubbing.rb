module Specs
  def self.stub_out_class_method(mod, meth)
    meta = (class << mod; self; end)
    original_meth = "original_#{meth}".to_sym

    if mod.respond_to?(original_meth)
      fail "ALREADY TRACED: #{mod}.#{meth}"
    end

    meta.send(:alias_method, original_meth, meth)
    meta.send(:define_method, meth) do |*args, &block|
      yield(*args) if block_given?
      mod.send original_meth, *args, &block
    end
  end
end
