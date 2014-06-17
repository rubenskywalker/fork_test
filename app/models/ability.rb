class Ability
  include CanCan::Ability

  def initialize(user, company)
    user ||= User.new
    company ||= Company.new
    if user.super_admin? || user.p_all?
      can :manage, :all if user.company_id == company.id
    end
    
    can :manage, Transaction, :only_for_search => true
    
    can :create, Transaction do |transaction|
      location = transaction.try(:location)
      if location.nil?
        user.location_permissions.map(&:l12).include?(true)
      else
        permission = location.location_permissions.find_by_user_id(user.id) || location.location_permissions.new()
        permission.l3? || user.location_permissions.map(&:l12).include?(true)
      end

    end
    
    can :create, User do |u|
      !user.company.real_free? && user.location_permissions.map(&:l1).include?(true)
    end
    
    can :manage, ChecklistMaster do |cm|
      user.p_master?
    end
    
    can :read, ChecklistMaster do |cm|
      user.p_master?
    end
    
    can :manage, Library do |l|
      user.p_library?
    end
    
    can :read, Library do |l|
      user.p_library?
    end
    
    can :read, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        permission.l2? || transaction.attach_contacts.map{|t| t.user}.include?(user) || transaction.user == user
      end
    end
    
    can :update, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        permission.l3? || (permission.l13? && transaction.user == user) #|| (transaction.attach_contacts.map{|t| t.user}.include?(user) && permission.l13?)
      end
    end
    
    
    can :upload_files, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l4?, transaction, user, permission.l15?)
      end
    end
    
    can :assign_files, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l8?, transaction, user, permission.l18?)
      end
    end
    
    can :add_notes, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l4?, transaction, user, permission.l15?)
      end
    end
    
    can :delete_files, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l6?, transaction, user, permission.l16?)
      end
    end
    
    can :destroy, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l6?, transaction, user, permission.l14?)
      end
    end
    
    
    can :add_remove_checklists, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l8?, transaction, user, permission.l13?)
      end
    end
    
    can :check_off_checklists, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l8?, transaction, user, permission.l13?)
      end
    end
    
    
    can :download, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        permission.l10? || permission.l2? || transaction.attach_contacts.map{|t| t.user}.include?(user) || transaction.user == user
      end
    end
    
    can :mark_file, Transaction do |transaction|
      permission = Ability.permissions(transaction, user)
      if permission.nil?
        true
      else
        Ability.contacts_include_permission?(permission.l11?, transaction, user, permission.l13?)
      end
    end
    
    
    
    
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
  
  def self.contacts_include_permission? main_permission, transaction, user, permission
    main_permission || (transaction.attach_contacts.map{|t| t.user}.include?(user) && permission) || transaction.user == user
  end
  
  def self.permissions transaction, user
    location = transaction.try(:location)
    if location.nil?
      nil
    else
      permission = location.location_permissions.find_by_user_id(user.id) || location.location_permissions.new()
    end
  end
  
end
