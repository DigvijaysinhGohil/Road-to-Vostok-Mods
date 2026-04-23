extends "res://Scripts/Interface.gd"

#const HOT_KEYS_DATA_PATH = "res://mods/InventoryHotKeys/InventoryHotKeys/InvetoryHotKeysData.tres" # For Testing
const HOT_KEYS_DATA_PATH = "res://InventoryHotKeys/InvetoryHotKeysData.tres" # For Deployment

var inventoryHotKeys

func _ready() -> void:
    inventoryHotKeys = load(HOT_KEYS_DATA_PATH)

func _physics_process(delta: float) -> void:
    super(delta)

    if !gameData.isTrading && !isInputting:
        CheckForUnloadMag()
        CheckForRemoveMag()
        CheckForRemoveOptic()
        CheckForRemoveLaser()
        CheckForRemoveMuzzle()
        CheckForSplitStack()
        CheckForTakeXAmount()

func CheckForUnloadMag() -> void:
    if gameData.isOccupied || gameData.isDead:
        return

    var unloadModifierPressed: bool = false
    match inventoryHotKeys.unloadModifierKey:
        0: unloadModifierPressed = true
        1: unloadModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: unloadModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: unloadModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var unloadKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.UNLOAD_MAG_ACTION)
    if unloadModifierPressed && unloadKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if visible && currentItem && currentGrid:
            if currentItem.slotData.itemData.subtype == "Magazine" && currentItem.slotData.amount != 0:
                UnloadMagazine(currentItem, currentGrid)
                HideToolTip()
                PlayClick()

func CheckForRemoveMag() -> void:
    var removeMagModifierPressed: bool = false
    match inventoryHotKeys.removeMagModifierKey:
        0: removeMagModifierPressed = true
        1: removeMagModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: removeMagModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: removeMagModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var removeMagKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.REMOVE_MAG_ACTION)
    if removeMagModifierPressed && removeMagKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if !currentItem:
            currentItem = GetHoverEquipment()
        if visible && currentItem:
            if currentItem.slotData.itemData.type != "Weapon": return
            RemoveMag(currentItem, currentGrid)

func CheckForRemoveOptic() -> void:
    var removeOpticModifierPressed: bool = false
    match inventoryHotKeys.removeOpticModifierKey:
        0: removeOpticModifierPressed = true
        1: removeOpticModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: removeOpticModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: removeOpticModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var removeOpticKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.REMOVE_OPTIC_ACTION)
    if removeOpticModifierPressed && removeOpticKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if !currentItem:
            currentItem = GetHoverEquipment()
        if visible && currentItem:
            if currentItem.slotData.itemData.type != "Weapon": return
            RemoveOpticSight(currentItem, currentGrid)

func CheckForRemoveLaser() -> void:
    var removeLaserModifierPressed: bool = false
    match inventoryHotKeys.removeLaserModifierKey:
        0: removeLaserModifierPressed = true
        1: removeLaserModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: removeLaserModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: removeLaserModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var removeLaserKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.REMOVE_LASER_ACTION)
    if removeLaserModifierPressed && removeLaserKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if !currentItem:
            currentItem = GetHoverEquipment()
        if visible && currentItem:
            if currentItem.slotData.itemData.type != "Weapon": return
            RemoveLaser(currentItem, currentGrid)

func CheckForRemoveMuzzle() -> void:
    var removeMuzzleModifierPressed: bool = false
    match inventoryHotKeys.removeMuzzleModifierKey:
        0: removeMuzzleModifierPressed = true
        1: removeMuzzleModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: removeMuzzleModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: removeMuzzleModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var removeMuzzleKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.REMOVE_MUZZLE_ACTION)
    if removeMuzzleModifierPressed && removeMuzzleKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if !currentItem:
            currentItem = GetHoverEquipment()
        if visible && currentItem:
            if currentItem.slotData.itemData.type != "Weapon": return
            RemoveMuzzle(currentItem, currentGrid)

func CheckForSplitStack() -> void:
    var splitModifierPressed: bool = false
    match inventoryHotKeys.splitModifierKey:
        0: splitModifierPressed = true
        1: splitModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: splitModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: splitModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var splitKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.SPLIT_ACTION)
    if splitModifierPressed && splitKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if visible && currentItem && currentGrid:
            SplitItems(currentItem, currentGrid)

func CheckForTakeXAmount() -> void:
    var takeModifierPressed: bool = false
    match inventoryHotKeys.takeModifierKey:
        0: takeModifierPressed = true
        1: takeModifierPressed = Input.is_key_pressed(KEY_SHIFT)
        2: takeModifierPressed = Input.is_key_pressed(KEY_ALT)
        3: takeModifierPressed = Input.is_key_pressed(KEY_CTRL)

    var takeKeyPressed: bool = Input.is_action_just_pressed(inventoryHotKeys.TAKE_ACTION)
    if takeModifierPressed && takeKeyPressed:
        var currentItem = GetHoverItem()
        var currentGrid = GetHoverGrid()
        if visible && currentItem && currentGrid:
            TakeXAmount(currentItem, currentGrid)

func RemoveMag(currentItem, currentGrid):
    var nestedItems: Array[ItemData] = currentItem.slotData.nested
    var magazineFound: bool = false
    var magazineIndex: int = -1
    for attachment in nestedItems:
        magazineIndex += 1
        if attachment.subtype == "Magazine":
            magazineFound = true
            break

    if !magazineFound: return

    var contextAmmo = currentItem.slotData.amount
    var removeItem = currentItem.Remove(magazineIndex)
    var newSlotData = SlotData.new()
    newSlotData.itemData = removeItem
    newSlotData.amount = contextAmmo

    if currentGrid:
        Create(newSlotData, currentGrid, true)
        HideToolTip()
        PlayAttach()
    else:
        rigManager.UpdateRig(false)
        if rigManager.get_child_count() != 0:
            var rig = rigManager.get_child(0)
            if rig is WeaponRig:
                rig.UpdateBulletsDetach(contextAmmo)

        Create(newSlotData, inventoryGrid, true)
        HideToolTip()
        PlayAttach()

func RemoveOpticSight(currentItem, currentGrid):
    var nestedItems: Array[ItemData] = currentItem.slotData.nested
    var opticSightFound: bool = false
    var opticSightIndex: int = -1
    for attachment in nestedItems:
        opticSightIndex += 1
        if attachment.subtype == "Optic":
            opticSightFound = true
            break

    if !opticSightFound: return

    var removeItem = currentItem.Remove(opticSightIndex)
    var newSlotData = SlotData.new()
    newSlotData.itemData = removeItem

    if currentGrid:
        Create(newSlotData, currentGrid, true)
        HideToolTip()
        PlayAttach()
    else:
        Create(newSlotData, inventoryGrid, true)
        HideToolTip()
        PlayAttach()

func RemoveMuzzle(currentItem, currentGrid):
    var nestedItems: Array[ItemData] = currentItem.slotData.nested
    var muzzleFound: bool = false
    var muzzleIndex: int = -1
    for attachment in nestedItems:
        muzzleIndex += 1
        if attachment.subtype == "Muzzle":
            muzzleFound = true
            break

    if !muzzleFound: return

    var removeItem = currentItem.Remove(muzzleIndex)
    var newSlotData = SlotData.new()
    newSlotData.itemData = removeItem

    if currentGrid:
        Create(newSlotData, currentGrid, true)
        HideToolTip()
        PlayAttach()
    else:
        Create(newSlotData, inventoryGrid, true)
        HideToolTip()
        PlayAttach()

func RemoveLaser(currentItem, currentGrid):
    var nestedItems: Array[ItemData] = currentItem.slotData.nested
    var laserFound: bool = false
    var laserIndex: int = -1
    for attachment in nestedItems:
        laserIndex += 1
        if attachment.subtype == "Laser":
            laserFound = true
            break

    if !laserFound: return

    var removeItem = currentItem.Remove(laserIndex)
    var newSlotData = SlotData.new()
    newSlotData.itemData = removeItem

    if currentGrid:
        Create(newSlotData, currentGrid, true)
        HideToolTip()
        PlayAttach()
    else:
        Create(newSlotData, inventoryGrid, true)
        HideToolTip()
        PlayAttach()

func SplitItems(currentItem, currentGrid):
    if currentItem.slotData.amount <= 1 || !currentItem.slotData.itemData.stackable:
        return
    var splitAmount = round(currentItem.slotData.amount / 2)
    currentItem.slotData.amount -= splitAmount
    currentItem.UpdateDetails()
    var newSlotData = SlotData.new()
    newSlotData.itemData = currentItem.slotData.itemData
    newSlotData.amount = splitAmount
    Create(newSlotData, currentGrid, true)
    HideToolTip()
    PlayStack()

func TakeXAmount(currentItem, currentGrid) -> void:
    var takeAmount = currentItem.slotData.itemData.defaultAmount
    if currentItem.slotData.amount <= takeAmount || !currentItem.slotData.itemData.stackable:
        return

    currentItem.slotData.amount -= takeAmount
    currentItem.UpdateDetails()
    var newSlotData = SlotData.new()
    newSlotData.itemData = currentItem.slotData.itemData
    newSlotData.amount = takeAmount
    Create(newSlotData, currentGrid, true)
    HideToolTip()
    PlayStack()

func HideToolTip() -> void:
    tooltip.visible = false
