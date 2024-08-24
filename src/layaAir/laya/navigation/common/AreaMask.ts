import { NavAreaFlag } from "./NavigationConfig";

/**
 * 区域遮罩
 */
export class AreaMask {
    /**@internal */
    private _flags: number;
    /**@internal */
    private _excludeflag: number;
    /**@internal */
    private _areaFlagMap: Map<string, NavAreaFlag>;

    /**
     * excludeflag
     */
    get excludeflag(): number {
        return this._excludeflag;
    }

    /**
    * flag
    */
    get flag(): number {
        return this._flags;
    }

    set flag(value: number) {
        this._flags = value;
        this._calculFlagVale();
    }
    constructor() {
        this._flags = 7;
    }

    /**
     * @internal
     */
    _setAreaMap(areaFlagMap: Map<string, NavAreaFlag>) {
        this._areaFlagMap = areaFlagMap;
        this._calculFlagVale();
    }

    /**
     * @internal
     */
    _calculFlagVale() {
        if (!this._areaFlagMap) return;
        let flag = 0;
        let excludeflag = 0;
        this._areaFlagMap.forEach((value, key) => {
            if (this._flags & value.flag) {
                flag = flag | value.flag;
            } else {
                excludeflag = excludeflag | value.flag;
            }
        })
        this._flags = flag;
        this._excludeflag = excludeflag;
    }
}