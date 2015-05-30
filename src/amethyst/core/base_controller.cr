abstract class BaseController
  getter   :actions_hash
  getter   :request
  property :response
  property :body
  # Creates a hash for controller actions
  # Then, invokes actions method to add actions to the hash
  def initialize(@request : Amethyst::Http::Request, @response : Amethyst::Http::Response)
    @actions_hash = {} of String => Proc
    actions
  end
  
  # Works like Ruby's send(:method) to invoke controller action:
  # NameController.call_action("show")
  def call_action(action)
    @actions_hash.fetch(action).call()
    return @response
  end

  def html(body : String)
    @response.body = body
    @response.header("Content-Type", "text/html")
  end

  # This hack creates procs from controller actions, and adds it to the @actions_hash
  macro add(action)
    @actions_hash[{{action}}.to_s] = ->{{action.id}}
  end

  # Adds all actions defined by user to @actions hash
  def actions
    # add :action_name
    # another actions
  end
end

# TODO: !!!Make actions not to accept anything at all, instead make private
# request method in the controller. Request must be instance variable of controller
# TODO: Separate module for html, answer etc. (mixin module)