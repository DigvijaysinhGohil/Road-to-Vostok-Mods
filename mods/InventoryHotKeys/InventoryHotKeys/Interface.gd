extends "res://Scripts/Interface.gd"

# Properties to determine the key press only on current frame
var hasUnloadMegKeyHeld: bool = false:
    set(value):
        if hasUnloadMegKeyHeld != value:
            hasUnloadMegKeyHeld = value
            if hasUnloadMegKeyHeld: FireUnloadMag()
    get: return hasUnloadMegKeyHeld

var hasRemoveMagKeyHeld: bool = false:
    set(value):
        if hasRemoveMagKeyHeld != value:
            hasRemoveMagKeyHeld = value
            if hasRemoveMagKeyHeld: FireRemoveMag()
    get: return hasRemoveMagKeyHeld

var hasRemoveOpticKeyHeld: bool = false:
    set(value):
        if hasRemoveOpticKeyHeld != value:
            hasRemoveOpticKeyHeld = value
            if hasRemoveOpticKeyHeld: FireRemoveOptic()
    get: return hasRemoveOpticKeyHeld

var hasRemoveLaserKeyHeld: bool = false:
    set(value):
        if hasRemoveLaserKeyHeld != value:
            hasRemoveLaserKeyHeld = value
            if hasRemoveLaserKeyHeld: FireRemoveLaser()
    get: return hasRemoveLaserKeyHeld

var hasRemoveMuzzleKeyHeld: bool = false:
    set(value):
        if hasRemoveMuzzleKeyHeld != value:
            hasRemoveMuzzleKeyHeld = value
            if hasRemoveMuzzleKeyHeld: FireRemoveMuzzle()
    get: return hasRemoveMuzzleKeyHeld

var hasSplitKeyHeld: bool = false:
    set(value):
        if hasSplitKeyHeld != value:
            hasSplitKeyHeld = value
            if hasSplitKeyHeld: FireSplit()
    get: return hasSplitKeyHeld

var hasTakeKeyHeld: bool = false:
    set(value):
        if hasTakeKeyHeld != value:
            hasTakeKeyHeld = value
            if hasTakeKeyHeld: FireTake()
    get: return hasTakeKeyHeld

var hasConsumeKeyHeld: bool = false:
    set(value):
        if hasConsumeKeyHeld != value:
            hasConsumeKeyHeld = value
            if hasConsumeKeyHeld: FireConsume()
    get: return hasConsumeKeyHeld

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
        CheckForConsumeItem()

func CheckForUnloadMag() -> void:
    # Shift + R
    if gameData.isOccupied || gameData.isDead: return
    hasUnloadMegKeyHeld = Input.is_key_pressed(KEY_SHIFT) && Input.is_key_pressed(KEY_R)

func CheckForRemoveMag() -> void:
    # Shift + R
    hasRemoveMagKeyHeld = Input.is_key_pressed(KEY_SHIFT) && Input.is_key_pressed(KEY_R)

func CheckForRemoveOptic() -> void:
    # Shift + F
    hasRemoveOpticKeyHeld = Input.is_key_pressed(KEY_SHIFT) && Input.is_key_pressed(KEY_F)

func CheckForRemoveLaser() -> void:
    # Shift + T
    hasRemoveLaserKeyHeld = Input.is_key_pressed(KEY_SHIFT) && Input.is_key_pressed(KEY_T)

func CheckForRemoveMuzzle() -> void:
    # Alt + F
    hasRemoveMuzzleKeyHeld = Input.is_key_pressed(KEY_ALT) && Input.is_key_pressed(KEY_F)

func CheckForSplitStack() -> void:
    # Shift + S
    hasSplitKeyHeld = Input.is_key_pressed(KEY_SHIFT) && Input.is_key_pressed(KEY_S)

func CheckForTakeXAmount() -> void:
    # Alt + S
    hasTakeKeyHeld = Input.is_key_pressed(KEY_ALT) && Input.is_key_pressed(KEY_S)

func CheckForConsumeItem() -> void:
    # Shift + E
    if gameData.isOccupied || gameData.isDead: return
    hasConsumeKeyHeld = Input.is_key_pressed(KEY_SHIFT) && Input.is_key_pressed(KEY_E)

func FireUnloadMag() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if visible && currentItem && currentGrid:
        if currentItem.slotData.itemData.subtype == "Magazine" && currentItem.slotData.amount != 0:
            UnloadMagazine(currentItem, currentGrid)
            HideToolTip()
            PlayClick()

func FireRemoveMag() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if !currentItem:
        currentItem = GetHoverEquipment()
    if visible && currentItem:
        if currentItem.slotData.itemData.type != "Weapon": return
        RemoveMag(currentItem, currentGrid)

func FireRemoveOptic() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if !currentItem:
        currentItem = GetHoverEquipment()
    if visible && currentItem:
        if currentItem.slotData.itemData.type != "Weapon": return
        RemoveOpticSight(currentItem, currentGrid)

func FireRemoveLaser() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if !currentItem:
        currentItem = GetHoverEquipment()
    if visible && currentItem:
        if currentItem.slotData.itemData.type != "Weapon": return
        RemoveLaser(currentItem, currentGrid)

func FireRemoveMuzzle() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if !currentItem:
        currentItem = GetHoverEquipment()
    if visible && currentItem:
        if currentItem.slotData.itemData.type != "Weapon": return
        RemoveMuzzle(currentItem, currentGrid)

func FireSplit() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if visible && currentItem && currentGrid:
        SplitItems(currentItem, currentGrid)

func FireTake() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if visible && currentItem && currentGrid:
        TakeXAmount(currentItem, currentGrid)

func FireConsume() -> void:
    var currentItem = GetHoverItem()
    var currentGrid = GetHoverGrid()
    if visible && currentItem && currentGrid:
        if !currentItem.slotData.itemData.usable || currentItem.slotData.state == "Frozen": return
        Use(currentItem, currentGrid)
        HideToolTip()
        PlayClick()

func RemoveMag(currentItem, currentGrid) -> void:
    var nestedItems: Array[ItemData] = currentItem.slotData.nested
    var magazineFound: bool = false
    var magazineIndex: int = -1
    for attachment in nestedItems:
        magazineIndex += 1
        if attachment.subtype == "Magazine":
            magazineFound = true
            break

    if !magazineFound:
        # Mag not found try to clear chamber.
        if gameData.isOccupied || gameData.isDead: return

        if currentItem.slotData.itemData.weaponAction != "Manual" && \
        currentItem.slotData.amount == 0 && currentItem.slotData.chamber && \
        currentItem.slotData.itemData.type == "Weapon":
            if !currentGrid:
                currentGrid = inventoryGrid
            UnloadWeapon(currentItem, currentGrid)
            HideToolTip()
            PlayClick()
        return

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

func RemoveOpticSight(currentItem, currentGrid) -> void:
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

func RemoveMuzzle(currentItem, currentGrid) -> void:
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

func RemoveLaser(currentItem, currentGrid) -> void:
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

func SplitItems(currentItem, currentGrid) -> void:
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
